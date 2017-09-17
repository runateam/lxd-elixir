defmodule LXD.Profile do
  alias LXD.Client

  defp url(profile_name \\ "") do
    ["/profiles", profile_name]
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

  def info(profile_name, opts \\ []) do
    url(profile_name)
    |> Client.get(opts)
  end

  def replace(profile_name, configs, opts \\ []) do
    url(profile_name)
    |> Client.put(configs, opts)
  end

  def update(profile_name, configs, opts \\ []) do
    url(profile_name)
    |> Client.patch(configs, opts)
  end

  def rename(profile_name, new_name, opts \\ []) do
    url(profile_name)
    |> Client.post(%{"name" => new_name}, opts)
  end

  def remove(profile_name, opts \\ []) do
    url(profile_name)
    |> Client.delete(opts)
  end

end
