defmodule LXD.Client do

  @socket_default "/var/lib/lxd/unix.socket"
  @version_default "/1.0"
  @response_handler_default LXD.ResponseHandler

  @version Application.get_env(:lxd, :api_version, @version_default)
  @url "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket, @socket_default)) <> @version
  @http_opts [{:recv_timeout, :infinity}]
  @headers %{"Content-Type" => "application/json"}
  @response_handler Application.get_env(:lxd, :response_handler, @response_handler_default)

  def get(endpoint, response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :get, "", response_opts, headers, opts)
  end

  def delete(endpoint, response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :delete, "", response_opts, headers, opts)
  end

  def post(endpoint, body \\ "", response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :post, body, response_opts, headers, opts)
  end

  def put(endpoint, body \\ "", response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :put, body, response_opts, headers, opts)
  end

  def patch(endpoint, body \\ "", response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :patch, body, response_opts, headers, opts)
  end

  defp request(endpoint, method, body \\ "", response_opts \\ [], headers \\ [], opts \\ [])

  defp request(endpoint, method, body, response_opts, headers, opts) when is_map(body) do
    case Poison.encode(body) do
      {:ok, json} ->
        request(endpoint, method, json, response_opts, headers, opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp request(endpoint, method, body, response_opts, headers, opts) when is_binary(body) do
    HTTPoison.request(
      method,
      @url <> endpoint,
      body,
      headers ++ @headers,
      opts ++ @http_opts
    )
    |> @response_handler.process(response_opts)
  end

end
