defmodule LXD.Network do
  alias LXD.Client

  defp url(network_name \\ "") do
    ["/networks", network_name]
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

  def info(network_name, opts \\ []) do
    url(network_name)
    |> Client.get(opts)
  end

  def replace(network_name, configs, opts \\ []) do
    url(network_name)
    |> Client.put(configs, opts)
  end

  def update(network_name, configs, opts \\ []) do
    url(network_name)
    |> Client.patch(configs, opts)
  end

  def rename(network_name, new_name, opts \\ []) do
    url(network_name)
    |> Client.post(%{ "name" => new_name }, opts)
  end

  def remove(network_name, opts \\ []) do
    url(network_name)
    |> Client.delete(opts)
  end

end
