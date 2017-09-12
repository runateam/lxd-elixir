defmodule LxdElixirTest do
  use ExUnit.Case
  doctest LxdElixir

  test "greets the world" do
    assert LxdElixir.hello() == :world
  end
end
