defmodule LXD.Storage do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn data ->
      data
      |> Enum.map(fn storage ->
        case as_url do
          true -> storage
          false -> storage |> String.split("/") |> List.last
        end
      end)
    end

    "/storage-pools"
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/storage-pools"
    |> Client.post(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def info(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/storage-pools/" <> name
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def replace(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/storage-pools/" <> name
    |> Client.put(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def update(name, configs, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/storage-pools/" <> name
    |> Client.patch(Poison.encode!(configs))
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

  def delete(name, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/storage-pools/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(raw: raw, type: :sync)
  end

end
