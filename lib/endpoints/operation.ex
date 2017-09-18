defmodule LXD.Operation do
  alias LXD.Client
  alias LXD.Utils

  def url(operation_uuid \\ "", opts \\ []) do
    wait = if(opts[:wait], do: "/wait", else: "")
    ["/operations", operation_uuid, wait]
    |> Path.join
  end

  def all(opts \\ []) do
    url()
    |> Client.get(opts)
  end

  def info(uuid, opts \\ []) do
    url(uuid)
    |> Client.get(opts)
  end

  def remove(uuid, opts \\ []) do
    url(uuid)
    |> Client.delete(opts)
  end

  def wait(uuid, opts \\ []) do
    timeout = Utils.arg(opts, :timeout, 0)
    uuid = uuid |> String.split("/") |> List.last

    timeout = case timeout do
      0 -> []
      _ -> [{"timeout", timeout}]
    end

    url(uuid, wait: true)
    |> Client.get(opts, [], params: timeout)
  end
end
