defmodule LXD.ResponseHandler do
  alias LXD.Utils

  def process(response, opts \\ [])

  def process({:ok, %HTTPoison.Response{body: body, headers: headers}}, opts) do
    wait = Utils.arg(opts, :wait, true)
    timeout = Utils.arg(opts, :timeout, 0)

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
    {:error, reason}
  end

  def process(_, _opts) do
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

end
