defmodule LXD.Container do
  alias LXD.Client
  alias LXD.Utils

  defp url(container_name \\ "", opts \\ []) do
    exec = if(opts[:exec], do: "/exec", else: "")
    state = if(opts[:state], do: "/state", else: "")
    metadata = if(opts[:metadata], do: "/metadata", else: "")
    ["/containers", container_name, exec, state, metadata]
    |> Path.join
  end

  @doc """
  List all containers
  """
  def all(opts \\ []) do
    url()
    |> Client.get(opts)
    |> case do
      {:ok, containers} ->
        {:ok, containers |> Enum.map(&Path.basename/1)}
      other ->
        other
    end
  end

  @doc """
  Create a new container

  `configs` is a map that define how to create the container

  See official documention for more details [here](https://github.com/lxc/lxd/blob/master/doc/rest-api.md#post-1)
  """
  def create(configs, opts \\ []) do
    url()
    |> Client.post(configs, opts)
  end

  @doc """
  Container information
  """
  def info(container_name, opts \\ []) do
    url(container_name)
    |> Client.get(opts)
  end

  @doc """
  Replace container configuration
  """
  def replace(container_name, configs, opts \\ []) do
    url(container_name)
    |> Client.put(configs, opts)
  end

  @doc """
  Update container configuration
  """
  def update(container_name, configs, opts \\ []) do
    url(container_name)
    |> Client.patch(configs, opts)
  end

  @doc """
  Rename the container
  """
  def rename(container_name, new_name, opts \\ []) do
    url(container_name)
    |> Client.post(%{"name" => new_name}, opts)
  end

  @doc """
  Remove the container
  """
  def remove(container_name, opts \\ []) do
    url(container_name)
    |> Client.delete(opts)
  end

  @doc """
  Run a remote command

  - `command`: must be a list splitted by space (see official documentation)
  - `envs`: map of environement variables to set

  Record output is set to true
  Return `{:ok, return_code, stdout, stderr}` if success
  Return `{:error, reason}` if error
  If stdout or stderr can't be read, `:error` is set instead

  Does not support websocket

  See official documention for more details [here](https://github.com/lxc/lxd/blob/master/doc/rest-api.md#10containersnameexec)
  """
  def exec(container_name, command, envs \\ %{}, opts \\ []) do
    configs = %{
      "command" => command,
      "environment" => envs,
      "record-output" => true
    }
    url(container_name, exec: true)
    |> Client.post(configs, opts)
    |> case do
      {:ok, %{"output" => %{"1" => stdout, "2" => stderr}, "return" => return}} ->
        get_result = fn log_name ->
          case LXD.Container.Log.get(container_name, log_name |> Path.basename) do
            {:ok, body} when is_binary(body) ->
              body
            _ ->
              :error
          end
        end
        {:ok, return, get_result.(stdout), get_result.(stderr)}
      {:ok, _body} ->
        {:error, "Cannot find output logs"}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  State of the container
  """
  def state(container_name, opts \\ []) do
    url(container_name, state: true)
    |> Client.get(opts)
  end

  @doc """
  Status of the container as a string
  """
  def status(name) do
    case state(name) do
      {:ok, %{"status" => value}} ->
        {:ok, value}
      other ->
        other
    end
  end

  @doc """
  Stop the container
  """
  def stop(container_name, opts \\ []) do
    state_change("stop", container_name, opts)
  end

  def start(container_name, opts \\ []) do
    state_change("start", container_name, opts)
  end

  def restart(container_name, opts \\ []) do
    state_change("restart", container_name, opts)
  end

  def freeze(container_name, opts \\ []) do
    state_change("freeze", container_name, opts)
  end

  def unfreeze(container_name, opts \\ []) do
    state_change("unfreeze", container_name, opts)
  end

  defp state_change(action, container_name, opts) do
    force = Utils.arg(opts, :force, false)
    timeout = Utils.arg(opts, :timeout, 0)
    stateful = Utils.arg(opts, :stateful, false)

    input = %{
      "action" => action,
      "timeout" => timeout,
      "force" => force,
      "stateful" => stateful
    }

    url(container_name, state: true)
    |> Client.put(input, opts)
    |> case do
      {:ok, %{"status_code" => 200}} ->
        :ok
      {:ok, %{"err" => error}} ->
        {:error, error}
      other ->
        other
    end
  end

  def metadata(container_name, opts \\ []) do
    url(container_name, metadata: true)
    |> Client.get(opts)
  end

end


defmodule LXD.Container.Template do
  alias LXD.Client

  defp url(container_name) do
    ["/containers", container_name, "/metadata/templates"]
    |> Path.join
  end

  def all(container_name, opts \\ []) do
    url(container_name)
    |> Client.get(opts)
  end

  def get(container_name, template_name, opts \\ []) do
    url(container_name)
    |> Client.get(opts, [], params: [{"path", template_name}])
  end

end


defmodule LXD.Container.Log do
  alias LXD.Client

  defp url(container_name, log_name \\ []) do
    ["/containers", container_name, "/logs", log_name]
    |> Path.join
  end

  def all(container_name, opts \\ []) do
    url(container_name)
    |> Client.get(opts)
    |> case do
      {:ok, data} ->
        {:ok, data |> Enum.map(&Path.basename/1)}
      others ->
        others
    end
  end

  def get(container_name, log_name, opts \\ []) do
    url(container_name, log_name)
    |> Client.get(opts)
  end

end


defmodule LXD.Container.File do
  alias LXD.Utils
  alias LXD.Client

  defp url(container_name) do
    ["/containers", container_name, "/files"]
    |> Path.join
  end

  def get(container_name, path_in_container, opts \\ []) do
    url(container_name)
    |> Client.get(opts, [], params: [{"path", path_in_container}])
  end

  def get_and_write(container_name, path_in_container, target_path, opts \\ []) do
    url(container_name)
    |> Client.get(opts, [], params: [{"path", path_in_container}])
    |> case do
      {:ok, ls} when is_list(ls) ->
        case File.mkdir(target_path) do
          :ok ->
            ls |> Enum.each(fn one ->
              get_and_write(
                container_name,
                [path_in_container, one] |> Path.join,
                [target_path, one] |> Path.join,
                opts
              )
            end)
          {:error, posix} ->
            {:error, "Cannot create directory #{target_path} (reason: #{:file.format_error(posix)})"}
        end
      {:ok, file_content} when is_binary(file_content) ->
        case File.write(target_path, file_content) do
          :ok ->
            :ok
          {:error, posix} ->
            {:error, "Cannot write in file #{target_path} (reason: #{:file.format_error(posix)})"}
        end
      other ->
        other
    end
  end

  defp put(container_name, path_in_container, type, content, opts) do
    append = Utils.arg(opts, :append, false)

    headers = [{"x-lxd-type", type}]
    headers = [{"x-lxd-write", if(append, do: "append", else: "overwrite")} | headers ]

    url(container_name)
    |> Client.post(content, opts, headers, params: [{"path", path_in_container}])
    |> case do
      {:ok, _} ->
        :ok
      others ->
        others
    end
  end

  def put_file(container_name, path_in_container, content, opts \\ []) do
    put(container_name, path_in_container, "file", content, opts)
  end

  def create_dir(container_name, path_in_container, opts \\ []) do
    put(container_name, path_in_container, "directory", "", opts)
  end

  def read_and_put(container_name, path_file, path_in_container, opts \\ []) do
    case File.exists?(path_file) do
      true ->
        case File.dir?(path_file) do
          true ->
            create_dir(container_name, path_in_container, opts)
            case File.ls(path_file) do
              {:ok, ls} ->
                ls |> Enum.reduce(:ok, fn(file, acc) ->
                  case acc do
                    :ok ->
                      read_and_put(
                        container_name,
                        [path_file, file] |> Path.join,
                        [path_in_container, file] |> Path.join,
                        opts
                      )
                    other ->
                      other
                  end
                end)
              {:error, reason} ->
                {:error, "Failed to list files in #{path_file} (reason: #{reason})"}
            end
          false ->
            case File.read(path_file) do
              {:ok, binary} ->
                put_file(container_name, path_in_container, binary)
              {:error, posix} ->
                {:error, "Failed to read file #{path_file} (#{:file.format_error(posix)})"}
            end
        end
      false ->
        {:error, "File #{path_file} doesn't exist"}
    end
  end

  def remove(container_name, path_in_container, opts \\ []) do
    url(container_name)
    |> Client.delete(opts, [], params: [{"path", path_in_container}])
  end

end


defmodule LXD.Container.Snapshot do
  alias LXD.Client

  defp url(container_name, snapshot_name \\ "") do
    ["/containers/", container_name, "/snapshots", snapshot_name]
    |> Path.join
  end

  def all(container_name, opts \\ []) do
    url(container_name)
    |> Client.get(opts)
  end

  def create(container_name, snapshot_name, stateful \\ true, opts \\ []) do
    input = %{
      "name" => snapshot_name,
      "stateful" => stateful
    }
    url(container_name)
    |> Client.post(input, opts)
  end

  def get(container_name, snapshot_name, opts \\ []) do
    url(container_name, snapshot_name)
    |> Client.get(opts)
  end

  def rename(container_name, snapshot_name, new_name, opts \\ []) do
    url(container_name, snapshot_name)
    |> Client.post(%{ "name" => new_name }, opts)
  end

  def remove(container_name, snapshot_name, opts \\ []) do
    url(container_name, snapshot_name)
    |> Client.delete(opts)
  end

end
