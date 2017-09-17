defmodule LXD.Client do
  require Logger

  @socket_default "/var/lib/lxd/unix.socket"
  @version_default "/1.0"
  @response_handler_default LXD.ResponseHandler

  @version Application.get_env(:lxd, :api_version, @version_default)
  @url "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket, @socket_default)) <> @version
  @http_opts [{:recv_timeout, :infinity}]
  @headers %{"Content-Type" => "application/json"}
  @response_handler Application.get_env(:lxd, :response_handler, @response_handler_default)

  def get(endpoint, response_opts \\ [], headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] GET #{endpoint}")
    @url <> endpoint
    |> HTTPoison.get(headers, @http_opts ++ opts)
    |> @response_handler.process(response_opts)
  end

  def post(endpoint, data \\ "", response_opts \\ [], headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] POST #{endpoint} #{data}")
    @url <> endpoint
    |> HTTPoison.post(data, headers, @http_opts ++ opts)
    |> @response_handler.process(response_opts)
  end

  def delete(endpoint, response_opts \\ [], headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] DELETE #{endpoint}")
    @url <> endpoint
    |> HTTPoison.delete(headers, @http_opts ++ opts)
    |> @response_handler.process(response_opts)
  end

  def put(endpoint, data \\ "", response_opts \\ [], headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] PUT #{endpoint} #{data}")
    @url <> endpoint
    |> HTTPoison.put(data, headers, @http_opts ++ opts)
    |> @response_handler.process(response_opts)
  end

  def patch(endpoint, data \\ "", response_opts \\ [], headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] PATCH #{endpoint} #{data}")
    @url <> endpoint
    |> HTTPoison.patch(data, headers, @http_opts ++ opts)
    |> @response_handler.process(response_opts)
  end

end
