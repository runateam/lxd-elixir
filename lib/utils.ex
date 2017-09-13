defmodule LXD.Utils do

  def handle_lxd_response({:ok, response}, opts \\ []) do
    raw = opts[:raw] || false
    type = opts[:type] || :sync
    fct = opts[:fct] || fn d -> d end

    case raw do
      true -> {:ok, response}
      false ->
        {:ok, response}
        |> handle_type(type)
        |> handle_data(fct)
    end
  end

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
