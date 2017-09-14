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
          false -> storage |> String.split("/") |> List.last
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

  def delete(name, opts \\ []) do
    "/storage-pools/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end
