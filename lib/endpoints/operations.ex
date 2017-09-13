defmodule LXD.Operations do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = opts[:raw] || false
    Client.get("/operations")
    |> Utils.handle_lxd_response(raw: raw,  type: :sync)
  end

  def get(uuid, opts \\ []) do
    raw = opts[:raw] || false
    Client.get("/operations/" <> uuid)
    |> Utils.handle_lxd_response(raw: raw,  type: :sync,)
  end

  def delete(uuid, opts \\ []) do
    raw = opts[:raw] || false
    Client.delete("/operations/" <> uuid)
    |> Utils.handle_lxd_response(raw: raw,  type: :sync)
  end

  def wait(uuid, opts \\ []) do
    raw = opts[:raw] || false

    timeout = case opts[:timeout] || nil do
      nil -> ""
      _ -> "?timeout=#{opts[:timeout]}"
    end
    Client.get("/operations/" <> uuid <> "/wait" <> timeout)
    |> Utils.handle_lxd_response(raw: raw,  type: :sync)
  end
end
