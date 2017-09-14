defmodule LXD.Client do
  require Logger

  @version Application.get_env(:lxd, :api_version)
  @url "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket)) <> @version
  @http_opts [{:recv_timeout, :infinity}]
  @headers %{"Content-Type" => "application/json"}

  def get(endpoint, headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] GET #{endpoint}")
    @url <> endpoint
    |> HTTPoison.get(headers, @http_opts ++ opts)
    |> handle_response
  end

  def post(endpoint, data \\ "", headers \\ @headers) do
    Logger.debug("[Client] POST #{endpoint} #{data}")
    @url <> endpoint
    |> HTTPoison.post(data, headers, @http_opts)
    |> handle_response
  end

  def delete(endpoint, headers \\ @headers, opts \\ []) do
    Logger.debug("[Client] DELETE #{endpoint}")
    @url <> endpoint
    |> HTTPoison.delete(headers, @http_opts ++ opts)
    |> handle_response
  end

  def put(endpoint, data \\ "", headers \\ @headers) do
    Logger.debug("[Client] PUT #{endpoint} #{data}")
    @url <> endpoint
    |> HTTPoison.put(data, headers, @http_opts)
    |> handle_response
  end

  def patch(endpoint, data \\ "", headers \\ @headers) do
    Logger.debug("[Client] PATCH #{endpoint} #{data}")
    @url <> endpoint
    |> HTTPoison.patch(data, headers, @http_opts)
    |> handle_response
  end


  defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body, headers: headers}}) do
    Logger.debug("[Client] Request response with #{code}")
    headers = headers
    |> Enum.map(fn {key, value} ->
      {key |> String.downcase, value}
    end)
    |> Map.new
    {:ok, headers, body}
  end

  defp handle_response({:error, %HTTPoison.Error{id: _id, reason: reason}}) do
    Logger.warn("[Client] Request failed with reason: #{reason}")
    {:error, reason}
  end

  defp handle_response(_) do
    Logger.warn("[Client] Request failed with reason: unknown")
    {:error, :unknown}
  end

end
