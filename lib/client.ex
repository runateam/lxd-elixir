defmodule LXD.Client do
  require Logger

  @url "http+unix://" <> URI.encode_www_form(Application.get_env(:lxd, :socket))

  def get(endpoint, headers \\ []) do
    url = @url <> endpoint
    Logger.debug("[Client] GET #{endpoint}")
    url
    |> HTTPoison.get(headers, recv_timeout: :infinity)
    |> handle_response
  end

  def post(endpoint, data \\ "", headers \\ []) do
    url = @url <> endpoint
    Logger.debug("[Client] POST #{endpoint}")
    url
    |> HTTPoison.post(data, headers, recv_timeout: :infinity)
    |> handle_response
  end


  defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}})
  when code == 200 do
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
