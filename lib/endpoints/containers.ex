defmodule LXD.Containers do
  require Logger
  alias LXD.Client
  alias LXD.Utils

  @version Application.get_env(:lxd, :api_version)

  def all(opts \\ []) do
    raw = opts[:raw] || false
    fct = fn data ->
      data
      |> Enum.map(fn container ->
        @version <> "/containers/" <> name = container
        name
      end)
    end

    Client.get(@version <> "/containers")
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end

  def create(template, opts \\ []) do
    raw = opts[:raw] || false
    wait = opts[:wait] || nil
    timeout = opts[:timeout] || nil

    result = Client.post(@version <> "/containers", Poison.encode!(template))
    |> Utils.handle_lxd_response(raw: raw, type: :async)

    case wait do
      nil ->
        result
      false ->
        result
      true ->
        case result do
          {:ok, {_op, data}} -> LXD.Operations.wait(data["id"], raw: raw, timeout: timeout)
          _ -> result
        end
    end
  end

end
