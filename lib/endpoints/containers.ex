defmodule LXD.Container do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      body["metadata"]
      |> Enum.map(fn container ->
        case as_url do
          true -> container
          false -> container |> String.split("/") |> List.last
        end
      end)
    end

    "/containers"
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def create(configs, opts \\ []) do
    "/containers"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def info(name, opts \\ []) do
    "/containers/" <> name
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def replace(name, configs, opts \\ []) do
    "/containers/" <> name
    |> Client.put(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def update(name, configs, opts \\ []) do
    "/containers/" <> name
    |> Client.patch(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def rename(name, new_name, opts \\ []) do
    "/containers/" <> name
    |> Client.post(Poison.encode!(%{"name" => new_name}))
    |> Utils.handle_lxd_response(opts)
  end

  def remove(name, opts \\ []) do
    "/containers/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

  def exec(name, configs, opts \\ []) do
    "/containers/" <> name <> "/exec"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def state(name, opts \\ []) do
    "/containers/" <> name <> "/state"
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def status(name) do
    response = state(name)
    case response do
      {:ok, body} ->
        {:ok, body["metadata"]["status"] || nil}
      _ ->
        response
    end
  end

  def stop(name, opts \\ []) do
    state_change("stop", name, opts)
  end

  def start(name, opts \\ []) do
    state_change("start", name, opts)
  end

  def restart(name, opts \\ []) do
    state_change("restart", name, opts)
  end

  def freeze(name, opts \\ []) do
    state_change("freeze", name, opts)
  end

  def unfreeze(name, opts \\ []) do
    state_change("unfreze", name, opts)
  end

  defp state_change(action, name, opts) do
    force = Utils.arg(opts, :force, false)
    timeout = Utils.arg(opts, :timeout, 0)
    stateful = Utils.arg(opts, :stateful, false)

    input = %{
      "action" => action,
      "timeout" => timeout,
      "force" => force,
      "stateful" => stateful
    }

    "/containers/" <> name <> "/state"
    |> Client.put(Poison.encode!(input))
    |> Utils.handle_lxd_response(opts)
  end

  def metadata(name, opts \\ []) do
    "/containers/" <> name <> "/metadata"
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

end


defmodule LXD.Container.Template do
  alias LXD.Utils
  alias LXD.Client

  def all(container_name, opts \\ []) do
    "/containers/" <> container_name <> "/metadata/templates"
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def get(name, template, opts \\ []) do
    "/containers/" <> name <> "/metadata/templates"
    |> Client.get([], params: [{"path", template}])
    |> Utils.handle_lxd_response(opts)
  end

end


defmodule LXD.Container.Log do
  alias LXD.Utils
  alias LXD.Client

  def all(name, opts \\ []) do
    "/containers/" <> name <> "/logs"
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def get(name, filename, opts \\ []) do
    fct = fn {:ok, _h, logs} -> logs |> String.split("\n") |> Enum.map(&String.trim&1) end
    "/containers/" <> name <> "/logs/" <> filename
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

end


defmodule LXD.Container.File do
  alias LXD.Utils
  alias LXD.Client

  def get(name, path_in_container, opts \\ []) do
    dir = Utils.arg(opts, :dir, System.cwd)

    fct = fn {:ok, headers, body} ->
      case headers["x-lxd-type"] do
        "file" ->
          filename = Regex.run(~r/filename=(.+)/, headers["content-disposition"], capture: :all_but_first) |> List.first
          filename = [dir, filename] |> Path.join

          File.open(filename, [:write], fn(file) ->
            IO.write(file, body)
          end)

          {:ok, filename}
        "directory" ->
          dirname = path_in_container |> Path.basename
          dirname = [dir, dirname] |> Path.join

          case File.mkdir(dirname) do
            :ok ->
              body["metadata"]
              |> Enum.each(fn one ->
                get(name, [path_in_container, one] |> Path.join, dir: dirname)
              end)
            {:error, posix} ->
              {:error, posix}
          end
          dirname
      end
    end

    "/containers/" <> name <> "/files"
    |> Client.get([], params: [{"path", path_in_container}])
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def put(name, path_file, path_in_container, opts \\ []) do
    append = Utils.arg(opts, :append, false)

    case File.exists?(path_file) do
      true ->
        {type, data} = case File.dir?(path_file) do
          true ->
            {"directory", ""}
          false ->
            case File.read(path_file) do
              {:ok, binary} ->
                {"file", binary}
              {:error, posix} ->
                {:error, "Failed to read file #{path_file} (#{:file.format_error(posix)})"}
            end
        end

        case type do
          :error ->
            {:error, data}
          _ ->
            headers = [{"x-lxd-type", type}]
            headers = [{"x-lxd-write", if(append, do: "append", else: "overwrite")} | headers ]

            "/containers/" <> name <> "/files"
            |> Client.post(data, headers, params: [{"path", path_in_container}])
            |> Utils.handle_lxd_response(opts)
        end
      false ->
        {:error, "File doesn't exist"}
    end
  end

  def remove(name, path_in_container, opts \\ []) do
    "/containers/" <> name <> "/files"
    |> Client.delete([], params: [{"path", path_in_container}])
    |> Utils.handle_lxd_response(opts)
  end

end


defmodule LXD.Container.Snapshot do
  alias LXD.Client
  alias LXD.Utils

  defp url(container_name, snapshot_name \\ "") do
    ["/containers/", container_name, "/snapshots", snapshot_name]
    |> Path.join
  end

  def all(container_name, opts \\ []) do
    url(container_name)
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def create(container_name, snapshot_name, stateful \\ true, opts \\ []) do
    %{
      "name" => snapshot_name,
      "stateful" => stateful
    }
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(container_name)
        |> Client.post(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def get(container_name, snapshot_name, opts \\ []) do
    url(container_name, snapshot_name)
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def rename(container_name, snapshot_name, new_name, opts \\ []) do
    %{ "name" => new_name }
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(container_name, snapshot_name)
        |> Client.post(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def remove(container_name, snapshot_name, opts \\ []) do
    url(container_name, snapshot_name)
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end
