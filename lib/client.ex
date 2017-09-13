defmodule LXD.Client do
  require Logger

  @url "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket))
  @http_opts [{:recv_timeout, :infinity}]

  def get(endpoint, headers \\ []) do
    Logger.debug("[Client] GET #{endpoint}")
    @url <> endpoint
    |> HTTPoison.get(headers, @http_opts)
    |> handle_response
  end

  def post(endpoint, data \\ "", headers \\ []) do
    Logger.debug("[Client] POST #{endpoint}")
    @url <> endpoint
    |> HTTPoison.post(data, headers, @http_opts)
    |> handle_response
  end

  def delete(endpoint, headers \\ []) do
    Logger.debug("[Client] DELETE #{endpoint}")
    @url <> endpoint
    |> HTTPoison.delete(headers, @http_opts)
    |> handle_response
  end


  defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    Logger.debug("[Client] Request response with #{code}")
    Poison.decode(body)
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
