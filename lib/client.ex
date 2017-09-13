defmodule LXD.Client do
  require Logger

  @url "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket))

  def get(endpoint) do
    url = @url <> endpoint
    Logger.debug("[Client] GET #{url}")
    HTTPoison.get(url)
  end
end
