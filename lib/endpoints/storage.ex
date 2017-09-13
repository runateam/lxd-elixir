defmodule LXD.Storage do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = opts[:raw] || false
    as_url = opts[:as_url] || false

    fct = fn data ->
      data
      |> Enum.map(fn storage ->
        case as_url do
          true -> storage
          false -> storage |> String.split("/") |> List.last
        end
      end)
    end

    Client.get("/storage-pools")
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(configs, opts \\ []) do
    raw = opts[:raw] || false
    Client.post("/storage-pools", Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def get(name, opts \\ []) do
    raw = opts[:raw] || false
    Client.get("/storage-pools/" <> name)
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def replace(name, configs, opts \\ []) do
    raw = opts[:raw] || false
    Client.put("/storage-pools/" <> name, Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def update(name, configs, opts \\ []) do
    raw = opts[:raw] || false
    Client.patch("/storage-pools/" <> name, Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def delete(name, opts \\ []) do
    raw = opts[:raw] || false
    Client.delete("/storage-pools/" <> name)
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

end
