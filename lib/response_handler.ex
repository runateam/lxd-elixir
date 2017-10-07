defmodule LXD.ResponseHandler do
  @moduledoc false
  alias LXD.Utils

  def process(response, opts \\ [])

  def process({:ok, %HTTPoison.Response{body: body, headers: headers}}, opts) do
    wait = Utils.arg(opts, :wait, true)
    timeout = Utils.arg(opts, :timeout, 0)

    case headers |> Map.new |> Map.fetch("Content-Type") do
      {:ok, "application/json"} ->
        process_json_body(body, wait, timeout)
      {:ok, _} ->
        {:ok, body}
      {:error} ->
        {:ok, body}
    end
  end

  def process({:error, %HTTPoison.Error{id: _id, reason: reason}}, _opts) do
    {:error, reason}
  end

  def process(_, _opts) do
    {:error, :unknown}
  end


  defp process_json_body(body, wait, timeout) do
    with  {:ok, body} <- Poison.decode(body)
    do
      body |> handle_json_body(wait, timeout)
    else
      {:error, reason} ->
        {:error, reason}
      error ->
        {:error, error}
    end
  end


  defp handle_json_body(body, wait \\ true, timeout \\ nil)

  defp handle_json_body(%{"type" => "error", "error" => error}, _, _) do
    {:error, error}
  end

  defp handle_json_body(%{"type" => "sync", "metadata" => metadata}, _, _) do
    {:ok, metadata}
  end

  defp handle_json_body(%{"type" => "async", "operation" => operation}, true, timeout) do
    LXD.Operation.wait(operation, timeout: timeout)
  end

  defp handle_json_body(%{"type" => "async", "metadata" => metadata}, _, _) do
    {:ok, metadata}
  end

end
