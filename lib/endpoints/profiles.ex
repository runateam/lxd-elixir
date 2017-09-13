defmodule LXD.Profile do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn data ->
      data
      |> Enum.map(fn profile ->
        case as_url do
          true -> profile
          false -> profile |> String.split("/") |> List.last
        end
      end)
    end

    "/profiles"
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(profile, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/profiles"
    |> Client.post(Poison.encode!(profile))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def info(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/profiles/" <> name
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def replace(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/profiles/" <> name
    |> Client.put(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def update(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/profiles/" <> name
    |> Client.patch(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def rename(name, new_name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/profiles/" <> name
    |> Client.post(Poison.encode!(%{"name" => new_name}))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def delete(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/profiles/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

end
