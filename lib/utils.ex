defmodule LXD.Utils do

  def arg(args, key, default \\ nil) do
    case List.keyfind(args, key, 0, nil) do
      {_, value } -> value
      _ -> default
    end
  end

  def handle_lxd_response(a, opts \\ [])
  def handle_lxd_response({:ok, headers, body}, opts) do
    fct = arg(opts, :fct, &default_apply_fct/1)
    wait = arg(opts, :wait, true)
    timeout = arg(opts, :timeout, 0)

    {:ok, headers, body}
    |> parse_body
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
              {:error, r1, r2} ->
                {:error, {r1, r2}}
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
  defp wait_operation({:ok, headers, body}, wait, timeout) when wait == true and is_map(body) do
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
  defp wait_operation(o, _, _), do: o


  def default_apply_fct({:ok, _headers, body}) do
    case is_map(body) do
      true ->
        case Map.fetch(body, "metadata") do
          {:ok, value} -> {:ok, value}
          :error -> {:ok, body}
        end
      false ->
        {:ok, body}
    end
  end

end
