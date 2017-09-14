defmodule LXD.Profile do
  alias LXD.Client
  alias LXD.Utils

  def all(opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      body["metadata"]
      |> Enum.map(fn profile ->
        case as_url do
          true -> profile
          false -> profile |> String.split("/") |> List.last
        end
      end)
    end

    "/profiles"
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def create(profile, opts \\ []) do
    "/profiles"
    |> Client.post(Poison.encode!(profile))
    |> Utils.handle_lxd_response(opts)
  end

  def info(name, opts \\ []) do
    "/profiles/" <> name
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def replace(name, configs, opts \\ []) do
    "/profiles/" <> name
    |> Client.put(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def update(name, configs, opts \\ []) do
    "/profiles/" <> name
    |> Client.patch(Poison.encode!(configs))
    |> Utils.handle_lxd_response(opts)
  end

  def rename(name, new_name, opts \\ []) do
    "/profiles/" <> name
    |> Client.post(Poison.encode!(%{"name" => new_name}))
    |> Utils.handle_lxd_response(opts)
  end

  def delete(name, opts \\ []) do
    "/profiles/" <> name
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end
