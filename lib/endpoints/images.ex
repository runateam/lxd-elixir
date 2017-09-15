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
      ls = body["metadata"]
      |> Enum.map(fn image ->
        case as_url do
          true -> image
          false -> image |> Path.basename
        end
      end)
      {:ok, ls}
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


defmodule LXD.Image.Alias do
  alias LXD.Client
  alias LXD.Utils

  defp url(alias_name \\ "") do
    ["/images/aliases", alias_name]
    |> Path.join
  end

  def all(opts \\ []) do
    as_url = Utils.arg(opts, :as_url, false)

    fct = fn {:ok, _headers, body} ->
      ls = body["metadata"]
      |> Enum.map(fn a ->
        case as_url do
          true -> a
          false -> a |> Path.basename
        end
      end)
      {:ok, ls}
    end

    url()
    |> Client.get
    |> Utils.handle_lxd_response(opts ++ [{:fct, fct}])
  end

  def create(alias_name, target, description \\ "", opts \\ []) do
    %{
      "name" => alias_name,
      "target" => target,
      "description" => description
    }
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

  def info(alias_name, opts \\ []) do
    url(alias_name)
    |> Client.get
    |> Utils.handle_lxd_response(opts)
  end

  def replace(alias_name, configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(alias_name)
        |> Client.put(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update(alias_name, configs, opts \\ []) do
    configs
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(alias_name)
        |> Client.patch(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def rename(alias_name, new_name, opts \\ []) do
    %{ "name" => new_name }
    |> Poison.encode
    |> case do
      {:ok, json} ->
        url(alias_name)
        |> Client.post(json)
        |> Utils.handle_lxd_response(opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def remove(alias_name, opts \\ []) do
    url(alias_name)
    |> Client.delete
    |> Utils.handle_lxd_response(opts)
  end

end
