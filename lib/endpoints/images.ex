defmodule LXD.Image do
  alias LXD.Client

  defp url() do
    ["/images"]
    |> Path.join
  end

  def all(opts \\ []) do
    url()
    |> Client.get(opts)
    |> case do
      {:ok, images} ->
        images |> Enum.map(&Path.basename/1)
      other ->
        other
    end
  end

end

defmodule LXD.Image.Fingerprint do
  alias LXD.Client

  defp url(fingerprint) do
    ["/images", fingerprint]
    |> Path.join
  end

  def info(fingerprint, opts \\ []) do
    url(fingerprint)
    |> Client.get(opts)
  end

  def replace(fingerprint, configs, opts \\ []) do
    url(fingerprint)
    |> Client.put(configs, opts)
  end

  def update(fingerprint, configs, opts \\ []) do
    url(fingerprint)
    |> Client.patch(configs, opts)
  end

  def remove(fingerprint, opts \\ []) do
    url(fingerprint)
    |> Client.delete(opts)
  end

end


defmodule LXD.Image.Alias do
  alias LXD.Client

  defp url(alias_name \\ "") do
    ["/images/aliases", alias_name]
    |> Path.join
  end

  def all(opts \\ []) do
    url()
    |> Client.get(opts)
    |> case do
      {:ok, images} ->
        images |> Enum.map(&Path.basename/1)
      other ->
        other
    end
  end

  def create(alias_name, target, description \\ "", opts \\ []) do
    input = %{
      "name" => alias_name,
      "target" => target,
      "description" => description
    }
    url()
    |> Client.post(input, opts)
  end

  def info(alias_name, opts \\ []) do
    url(alias_name)
    |> Client.get(opts)
  end

  def replace(alias_name, configs, opts \\ []) do
    url(alias_name)
    |> Client.put(configs, opts)
  end

  def update(alias_name, configs, opts \\ []) do
    url(alias_name)
    |> Client.patch(configs, opts)
  end

  def rename(alias_name, new_name, opts \\ []) do
    url(alias_name)
    |> Client.post(%{ "name" => new_name }, opts)
  end

  def remove(alias_name, opts \\ []) do
    url(alias_name)
    |> Client.delete(opts)
  end

end
