defmodule LXD.Utils do

  def handle_lxd_response(a, opts \\ [])
  def handle_lxd_response({:ok, headers, body}, opts) do
    fct = arg(opts, :fct, fn({:ok, _h, b}) -> {:ok, b} end)
    wait = arg(opts, :wait, true)
    timeout = arg(opts, :timeout, 0)

    {:ok, headers, body}
    |> parse_body
    |> IO.inspect
    |> wait_operation(wait, timeout)
    |> apply_fct(fct)
  end
  def handle_lxd_response({:error, _} = o, _opts), do: o


  defp parse_body({:ok, headers, body}) do
    case Map.fetch(headers, "content-type") do
      {:ok, value} ->
        case value do
          "application/json" ->
            case Poison.decode(body) do
              {:ok, value} ->
                {:ok, headers, value}
              {:error, reason} ->
                {:error, reason}
            end
          _ ->
            {:ok, headers, body}
        end
      :error ->
        {:ok, headers, body}
    end
  end
  defp parse_body({:error, _} = o), do: o


  defp apply_fct({:ok, headers, body}, fct) do
    fct.({:ok, headers, body})
  end
  defp apply_fct({:ok, body}, fct) do
    fct.({:ok, %{}, body})
  end
  defp apply_fct({:error, _} = o, _fct), do: o


  defp wait_operation(a, wait \\ true, timeout \\ nil)
  defp wait_operation({:ok, headers, body}, wait, timeout) do
    case wait do
      false ->
        {:ok, headers, body}
      true ->
        case Map.fetch(body, "operation") do
          {:ok, value} ->
            case String.length(value) do
              0 ->
                {:ok, headers, body}
              _ ->
                LXD.Operation.wait(value, timeout: timeout)
            end
          :error ->
            {:ok, headers, body}
        end
    end
  end
  defp wait_operation({:error, _} = o, _wait, _timeout), do: o


  def arg(args, key, default \\ nil) do
    case List.keyfind(args, key, 0, nil) do
      {_, value } -> value
      _ -> default
    end
  end

end
