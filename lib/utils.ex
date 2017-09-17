defmodule LXD.Utils do

  def arg(args, key, default \\ nil) do
    case List.keyfind(args, key, 0, nil) do
      {_, value } -> value
      _ -> default
    end
  end

end
