defmodule LXD.Operation do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    "/operations"
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def info(uuid, opts \\ []) do
    "/operations/" <> uuid
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def remove(uuid, opts \\ []) do
    "/operations/" <> uuid
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

  def wait(uuid, opts \\ []) do
    timeout = Utils.arg(opts, :timeout, 0)
    uuid = uuid |> String.split("/") |> List.last

    timeout = case timeout do
      0 -> ""
      _ -> "?timeout=#{timeout}"
    end

    "/operations/" <> uuid <> "/wait" <> timeout
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end
end
