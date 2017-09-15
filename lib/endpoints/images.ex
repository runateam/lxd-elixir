defmodule LXD.Image do
  alias LXD.Client
  alias LXD.Utils

  defp url() do
    ["/images"]
    |> Path.join
  end

  def all(opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      body["metadata"]
      |> Enum.map(fn image ->
        case as_url do
          true -> image
          false -> image |> Path.basename
        end
      end)
    end

    url()
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

end

defmodule LXD.Image.Fingerprint do
  alias LXD.Client
  alias LXD.Utils

  defp url(fingerprint) do
    ["/images", fingerprint]
    |> Path.join
  end

  def info(fingerprint, opts \\ []) do
    url(fingerprint)
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def replace(fingerprint, configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(fingerprint)
        |> Client.put(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update(fingerprint, configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(fingerprint)
        |> Client.patch(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def remove(fingerprint, opts \\ []) do
    url(fingerprint)
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end
