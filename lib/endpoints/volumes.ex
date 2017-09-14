defmodule LXD.Volume do
  alias LXD.Client
  alias LXD.Utils

  def all(storage_name, opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      body["metadata"]
      |> Enum.map(fn volume ->
        case as_url do
          true -> volume
          false -> volume |> String.split("/") |> List.last
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
