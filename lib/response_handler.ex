defmodule LXD.ResponseHandler do
  alias LXD.Utils
  require Logger

  def process(response, opts \\ [])

  def process({:ok, %HTTPoison.Response{status_code: code, body: body, headers: headers}}, opts) do
    #fct = Utils.arg(opts, :fct, &default_apply_fct/1)
    wait = Utils.arg(opts, :wait, true)
    timeout = Utils.arg(opts, :timeout, 0)

    Logger.debug("[Client] Response with #{code}")

    headers = headers
    |> Enum.map(fn {key, value} ->
      {key |> String.downcase, value}
    end)
    |> Map.new

    {:ok, headers, body}
    |> parse_body
    |> wait_operation(wait, timeout)
  end

  def process({:error, %HTTPoison.Error{id: _id, reason: reason}}, _opts) do
    Logger.warn("[Client] Request failed with reason: #{reason}")
    {:error, reason}
  end

  def process(_, _opts) do
    Logger.warn("[Client] Request failed with reason: unknown")
    {:error, :unknown}
  end


  defp parse_body({:ok, %{"content-type" => "application/json"} = headers, body}) do
    case Poison.decode(body) do
      {:ok, value} ->
        {:ok, headers, value}
      {:error, reason} ->
        {:error, reason}
      {:error, r1, r2} ->
        {:error, {r1, r2}}
    end
  end

  defp parse_body({:ok, _header, _body} = o), do: o


  defp wait_operation(a, wait \\ true, timeout \\ nil)
  defp wait_operation({:ok, _headers, %{"type" => "async", "operation" => operation}}, wait, timeout) when wait == true and byte_size(operation) > 0 do
    LXD.Operation.wait(operation, timeout: timeout)
  end
  defp wait_operation(o, _wait, _timeout), do: o


  # defp apply_fct({:ok, headers, body}, fct) do
  #   fct.({:ok, headers, body})
  # end
  # defp apply_fct({:ok, body}, fct) do
  #   fct.({:ok, %{}, body})
  # end
  # defp apply_fct({:error, _} = o, _fct), do: o
  #
  # def default_apply_fct({:ok, _headers, body}) do
  #   case is_map(body) do
  #     true ->
  #       case Map.fetch(body, "metadata") do
  #         {:ok, value} -> {:ok, value}
  #         :error -> {:ok, body}
  #       end
  #     false ->
  #       {:ok, body}
  #   end
  # end

end
