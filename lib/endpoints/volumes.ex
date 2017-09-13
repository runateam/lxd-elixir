defmodule LXD.Volumes do
  alias LXD.Client
  alias LXD.Utils

  def all(storage_name, opts \\ []) do
    raw = opts[:raw] || false
    as_url = opts[:as_url] || false

    fct = fn data ->
      data
      |> Enum.map(fn volume ->
        case as_url do
          true -> volume
          false -> volume |> String.split("/") |> List.last
        end
      end)
    end

    Client.get("/storage-pools/" <> storage_name <> "/volumes")
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(storage_name, configs, opts \\ []) do
    raw = opts[:raw] || false
    Client.post("/storage-pools/" <> storage_name <> "/volumes", Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

end
