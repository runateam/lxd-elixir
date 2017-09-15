defmodule LXD.Network do
  alias LXD.Client
  alias LXD.Utils

  defp url(network_name \\ "") do
    ["/networks", network_name]
    |> Path.join
  end

  def all(opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      ls = body["metadata"]
      |> Enum.map(fn network ->
        case as_url do
          true -> network
          false -> network |> Path.basename
        end
      end)
      {:ok, ls}
    end

    url()
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def create(configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url()
        |> Client.post(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def info(network_name, opts \\ []) do
    url(network_name)
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def replace(network_name, configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(network_name)
        |> Client.put(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update(network_name, configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(network_name)
        |> Client.patch(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def rename(network_name, new_name, opts \\ []) do
    %{ "name" => new_name }
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(network_name)
        |> Client.post(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def remove(network_name, opts \\ []) do
    url(network_name)
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end
