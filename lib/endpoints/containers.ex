defmodule LXD.Container do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn data ->
      data
      |> Enum.map(fn container ->
        case as_url do
          true -> container
          false -> container |> String.split("/") |> List.last
        end
      end)
    end

    "/containers"
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    wait = Utils.arg(opts, :wait, true)
    timeout = Utils.arg(opts, :timeout, 0)

    "/containers"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :async)
    |> Utils.wait_operation(wait, timeout, raw)
  end

  def info(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/containers/" <> name
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def replace(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/containers/" <> name
    |> Client.put(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def update(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/containers/" <> name
    |> Client.patch(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def rename(name, new_name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/containers/" <> name
    |> Client.post(Poison.encode!(%{"name" => new_name}))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def delete(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/containers/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def exec(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    wait = Utils.arg(opts, :wait, true)
    timeout = Utils.arg(opts, :timeout, 0)

    "/containers/" <> name <> "/exec"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :async)
    |> Utils.wait_operation(wait, timeout, raw)
  end

  # defmodule LXD.Container.File do
    # def file_get(name, path_in_container, opts \\ []) do
    #   raw = opts[:raw] || false
    #   path = "?path=#{path_in_container}"
    #   "/containers/" <> name <> "/files" <> path
    #   |> Client.get
    #   |> Utils.
    # end
  # end

  def state(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/containers/" <> name <> "/state"
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def status(name) do
    response = state(name)
    case response do
      {:ok, body} ->
        case Map.fetch(body, "status") do
          {:ok, value} -> {:ok, value}
          :error -> {:error, "Cannot find status in response"}
        end
      _ -> response
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
    raw = Utils.arg(opts, :raw, false)
    wait = Utils.arg(opts, :wait, true)
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
    |> Utils.handle_lxd_response(raw: raw, type: :async)
    |> Utils.wait_operation(wait, timeout, raw)
  end

end
