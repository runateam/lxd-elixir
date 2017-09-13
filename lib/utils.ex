defmodule LXD.Utils do

  def handle_lxd_response(a, opts \\ [])
  def handle_lxd_response({:ok, mime, response}, opts) do
    raw = arg(opts, :raw, false)
    type = arg(opts, :type, :sync)
    fct = arg(opts, :fct, fn d -> d end)

    case mime do
      "application/json" ->
        case raw do
          true -> {:ok, response}
          false ->
            {:ok, response}
            |> handle_type(type)
            |> handle_data(fct)
        end
      "application/octet-stream" ->
        {:ok, response}
        |> handle_data(fct)
      _ ->
        {:ok, response}
    end
  end
  def handle_lxd_response({:error, _} = o, _opts), do: o

  def handle_type({:ok, response}, :sync) do
    parse_response_type(response)
    |> case do
      {:sync, _, data} -> {:ok, data}
      {:error, reason, data} -> {:error, {reason, data}}
      bad -> {:error, bad}
    end
  end
  def handle_type({:error, _} = o, :sync), do: o

  def handle_type({:ok, response}, :async) do
    parse_response_type(response)
    |> case do
      {:async, _, operation, data} -> {:ok, {operation, data}}
      {:error, reason, data} -> {:error, {reason, data}}
      bad -> {:error, bad}
    end
  end
  def handle_type({:error, _} = o, :async), do: o

  def handle_data({:ok, {operation, data}}, fct) do
    {:ok, {operation, fct.(data)}}
  end
  def handle_data({:ok, data}, fct) do
    {:ok, fct.(data)}
  end
  def handle_data({:error, _} = o, _fct), do: o


  def wait_operation(response, wait \\ true, timeout \\ nil, raw \\ false) do
    case wait do
      false ->
        response
      true ->
        case response do
          {:ok, {_op, data}} ->
            case Map.fetch(data, "id") do
              {:ok, value} ->
                LXD.Operation.wait(value, raw: raw, timeout: timeout)
              :error -> response
            end
          _ -> response
        end
    end
  end

  def arg(args, key, default \\ nil) do
    case List.keyfind(args, key, 0, nil) do
      {_, value } -> value
      _ -> default
    end
  end

  defp parse_response_type(response) do
    case response["type"] do
      "sync" ->
        {:sync, response["status"], response["metadata"]}
      "async" ->
        {:async, response["status"], response["operation"], response["metadata"]}
      "error" ->
        metadata = case Map.fetch(response, "metadata") do
          {:ok, value} -> value
          :error -> %{}
        end
        {:error, response["error"], metadata}
    end
  end

end
