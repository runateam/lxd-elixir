defmodule LXD.Profiles do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = opts[:raw] || false
    as_url = opts[:as_url] || false

    fct = fn data ->
      data
      |> Enum.map(fn profile ->
        case as_url do
          true -> profile
          false -> profile |> String.split("/") |> List.last
        end
      end)
    end

    Client.get("/profiles")
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(profile, opts \\ []) do
    raw = opts[:raw] || false
    Client.post("/profiles", Poison.encode!(profile))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def info(name, opts \\ []) do
    raw = opts[:raw] || false
    Client.get("/profiles/" <> name)
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def replace(name, informations, opts \\ []) do
    raw = opts[:raw] || false
    Client.put("/profiles/" <> name, Poison.encode!(informations))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def update(name, informations, opts \\ []) do
    raw = opts[:raw] || false
    Client.patch("/profiles/" <> name, Poison.encode!(informations))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def rename(name, new_name, opts \\ []) do
    raw = opts[:raw] || false
    Client.post("/profiles/" <> name, Poison.encode!(%{"name" => new_name}))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def delete(name, opts \\ []) do
    raw = opts[:raw] || false
    Client.delete("/profiles/" <> name)
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end
end
