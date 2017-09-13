defmodule LXD.Profiles do
  alias LXD.Client
  alias LXD.Utils

  @version Application.get_env(:lxd, :api_version)

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

    Client.get(@version <> "/profiles")
    |> Utils.handle_lxd_response(raw: raw, type: :sync, fct: fct)
  end
end
