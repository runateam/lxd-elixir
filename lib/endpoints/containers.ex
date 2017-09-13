defmodule LXD.Containers do
  require Logger
  alias LXD.Client

  @version Application.get_env(:lxd, :api_version)

  def all() do
    case all(:raw) do
      {:ok, body} ->
        case LXD.Utils.handle_lxd_response(body) do
          {:sync, _, data} ->
            data
            |> Enum.map(fn container ->
              @version <> "/containers/" <> name = container
              name
            end)
          error ->
            {:error, error}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def all(:raw) do
    Client.get(@version <> "/containers")
  end
end
