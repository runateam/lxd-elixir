defmodule LXD.Storage do
  alias LXD.Client

  defp url(storage_name \\ "") do
    ["/storage-pools", storage_name]
    |> Path.join
  end

  def all(opts \\ []) do
    url()
    |> Client.get(opts)
  end

  def create(configs, opts \\ []) do
    url()
    |> Client.post(configs, opts)
  end

  def info(storage_name, opts \\ []) do
    url(storage_name)
    |> Client.get(opts)
  end

  def replace(storage_name, configs, opts \\ []) do
    url(storage_name)
    |> Client.put(configs, opts)
  end

  def update(storage_name, configs, opts \\ []) do
    url(storage_name)
    |> Client.patch(configs, opts)
  end

  def remove(storage_name, opts \\ []) do
    url(storage_name)
    |> Client.delete(opts)
  end

end

defmodule LXD.Storage.Volume do
  alias LXD.Client

  defp url(storage_name) do
    ["/storage-pools", storage_name, "/volumes"]
    |> Path.join
  end

  def all(storage_name, opts \\ []) do
    url(storage_name)
    |> Client.get(opts)
  end

  def create(storage_name, configs, opts \\ []) do
    url(storage_name)
    |> Client.post(configs, opts)
  end

end
