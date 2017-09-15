defmodule LXD.Storage do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      body["metadata"]
      |> Enum.map(fn storage ->
        case as_url do
          true -> storage
          false -> storage |> Path.basename
        end
      end)
    end

    "/storage-pools"
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def create(configs, opts \\ []) do
    "/storage-pools"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def info(name, opts \\ []) do
    "/storage-pools/" <> name
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def replace(name, configs, opts \\ []) do
    "/storage-pools/" <> name
    |> Client.put(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def update(name, configs, opts \\ []) do
    "/storage-pools/" <> name
    |> Client.patch(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def remove(name, opts \\ []) do
    "/storage-pools/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end

defmodule LXD.Storage.Volume do
  alias LXD.Client
  alias LXD.Utils

  def all(storage_name, opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      body["metadata"]
      |> Enum.map(fn volume ->
        case as_url do
          true -> volume
          false -> volume |> Path.basename
        end
      end)
    end

    "/storage-pools/" <> storage_name <> "/volumes"
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def create(storage_name, configs, opts \\ []) do
    "/storage-pools/" <> storage_name <> "/volumes"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

end
