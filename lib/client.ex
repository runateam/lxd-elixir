defmodule LXD.Client do
  @moduledoc false
  alias LXD.Utils

  @socket_default "/var/lib/lxd/unix.socket"
  @version_default "/1.0"
  @response_handler_default LXD.ResponseHandler

  @headers [{"Content-Type", "application/json"}]

  @doc """
  GET request to the given endpoint
  """
  def get(endpoint, response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :get, "", response_opts, headers, opts)
  end

  @doc """
  DELETE request to the given endpoint
  """
  def delete(endpoint, response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :delete, "", response_opts, headers, opts)
  end

  @doc """
  POST request to the given endpoint
  """
  def post(endpoint, body \\ "", response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :post, body, response_opts, headers, opts)
  end

  @doc """
  PUT request to the given endpoint
  """
  def put(endpoint, body \\ "", response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :put, body, response_opts, headers, opts)
  end

  @doc """
  PATCH request to the given endpoint
  """
  def patch(endpoint, body \\ "", response_opts \\ [], headers \\ [], opts \\ []) do
    request(endpoint, :patch, body, response_opts, headers, opts)
  end


  # Request to the given endpoint with the given HTTP method
  # If body is a map, it will be convert to a string with Poison
  defp request(endpoint, method, body \\ "", response_opts \\ [], headers \\ [], opts \\ [])

  defp request(endpoint, method, body, response_opts, headers, opts)
  when is_map(body) do
    case Poison.encode(body) do
      {:ok, json} ->
        request(endpoint, method, json, response_opts, headers, opts)
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp request(endpoint, method, body, response_opts, headers, opts)
  when is_binary(body) do
    version = case Utils.arg(response_opts, :append_version, true) do
      true -> Application.get_env(:lxd, :api_version, @version_default)
      false -> ""
    end

    url = case Application.get_env(:lxd, :remote, false) do
      true -> Application.get_env(:lxd, :url, nil)
      false -> "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket, @socket_default))
    end

    unless url do
      raise RuntimeError, """
      No URL is configured for LXD API. Update your config before making an API call.


          config :lxd,
            url: "https://lxd.dev:8443"
      """
    end

    response_handler = Application.get_env(:lxd, :response_handler, @response_handler_default)

    HTTPoison.request(
      method,
      [url, version, endpoint] |> Path.join,
      body,
      headers ++ @headers,
      opts ++ Application.get_env(:lxd, :http_opts, [])
    )
    |> response_handler.process(response_opts)
  end

end
