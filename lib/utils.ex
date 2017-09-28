defmodule LXD.Utils do
  @moduledoc false

  # Get value by given key from arg keyword list
  # Return value or default if key doesn't exist
  def arg(args, key, default \\ nil) do
    case List.keyfind(args, key, 0, nil) do
      {_, value } -> value
      _ -> default
    end
  end

end
