defmodule LXD.Operation do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/operations"
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw,  type: :sync)
  end

  def info(uuid, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/operations/" <> uuid
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw,  type: :sync,)
  end

  def delete(uuid, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    "/operations/" <> uuid
    |> Client.delete
    |> Utils.handle_lxd_response(raw: raw,  type: :sync)
  end

  def wait(uuid, opts \\ []) do
    raw = Utils.arg(opts, :raw, false)
    timeout = Utils.arg(opts, :timeout, 0)

    timeout = case timeout do
      0 -> ""
      _ -> "?timeout=#{timeout}"
    end

    "/operations/" <> uuid <> "/wait" <> timeout
    |> Client.get
    |> Utils.handle_lxd_response(raw: raw,  type: :sync)
  end
end
