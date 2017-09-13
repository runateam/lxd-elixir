defmodule LXD.Utils do

  def handle_lxd_response(response) do
    case response["type"] do
      "sync" ->
        {:sync, response["status"], response["metadata"]}
      "async" ->
        {:async, response["status"], {response["operation"], response["metadata"]}}
      "error" ->
        {:error, response["error"], response["metadata"]}
    end
  end

end
