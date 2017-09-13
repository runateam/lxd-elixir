defmodule LXD.Volume do
  alias LXD.Client
  alias LXD.Utils

  def all(storage_name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn data ->
      data
      |> Enum.map(fn volume ->
        case as_url do
          true -> volume
          false -> volume |> String.split("/") |> List.last
        end
      end)
    end

    "/storage-pools/" <> storage_name <> "/volumes"
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(storage_name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/storage-pools/" <> storage_name <> "/volumes"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

end
