defmodule UtilsTest do
  use ExUnit.Case
  alias LXD.Utils

  test "arg return default" do
    assert Utils.arg([], :key, :default) == :default
    assert Utils.arg([], :key) == nil
  end

  test "arg return value" do
    assert Utils.arg([key: :value, kkey: :vvalue], :kkey) == :vvalue
  end

  # test "handle_lxd_response no content-type" do
  #   i = {:ok, %{}, :ok}
  #   o = {:ok, :ok}
  #   assert Utils.handle_lxd_response(i) == o
  # end
  #
  # test "handle_lxd_response with content-type" do
  #   i = {:ok, %{"content-type" => "a"}, :ok}
  #   o = {:ok, :ok}
  #   assert Utils.handle_lxd_response(i) == o
  # end
  #
  # test "handle_lxd_response with empty json" do
  #   i = {:ok, %{"content-type" => "application/json"}, "{}"}
  #   o = {:ok, %{}}
  #   assert Utils.handle_lxd_response(i) == o
  # end
  #
  # test "handle_lxd_response with bad json" do
  #   i = {:ok, %{"content-type" => "application/json"}, ""}
  #   o = {:error, {:invalid, 0}}
  #   assert Utils.handle_lxd_response(i) == o
  # end
  #
  # test "handle_lxd_response with custom fct" do
  #   i = {:ok, %{}, :ok}
  #   o = :out
  #   fct = fn {:ok, %{}, :ok} -> :out end
  #   assert Utils.handle_lxd_response(i, fct: fct) == o
  # end

end
