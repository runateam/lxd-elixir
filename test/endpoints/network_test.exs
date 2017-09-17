# defmodule NetworkTest do
#   use ExUnit.Case, async: false
#   alias LXD.Network
#
#   @network_name "ex-test"
#   @network_cfg %{
#     "name" => @network_name,
#     "description" => "elixir test",
#     "managed" => true
#   }
#
#   setup context do
#     if context[:create] do
#       Network.remove(@network_name)
#       Network.create(@network_cfg)
#     end
#
#     if context[:remove] do
#       on_exit fn -> Network.remove(@network_name) end
#     end
#
#     :ok
#   end
#
#   @tag :remove
#   test "create" do
#     {:ok, _, %{"status_code" => status_code}} = Network.create(@network_cfg)
#     assert status_code == 200
#   end
#
#   @tag :create
#   test "remove" do
#     {:ok, _, %{"status_code" => status_code}} = Network.remove(@network_name)
#     assert status_code == 200
#   end
#
#   test "all" do
#     {:ok, _, %{"status_code" => status_code}} = Network.all
#     assert status_code == 200
#   end
#
#   @tag :create
#   @tag :remove
#   test "info" do
#     {:ok, _, %{"status_code" => status_code}} = Network.info(@network_name)
#     assert status_code == 200
#   end
#
#   @tag :create
#   @tag :remove
#   test "replace" do
#     {:ok, _, %{"status_code" => status_code}} = Network.replace(@network_name, %{"description" => "a"})
#     assert status_code == 200
#   end
#
#   @tag :create
#   @tag :remove
#   test "update" do
#     {:ok, _, %{"status_code" => status_code}} = Network.update(@network_name, %{"description" => "a"})
#     assert status_code == 200
#   end
#
# @tag :create
# test "rename" do
#   new_name = @network_name <> "-renamed"
#   {:ok, _, %{"status_code" => status_code}} = Network.rename(@network_name, new_name)
#   assert status_code == 200
#   {:ok, _, %{"status_code" => status_code}} = Network.remove(new_name)
#   assert status_code == 200
# end
#
# @tag :create
# @tag :remove
# test "rename with same" do
#   {:ok, _, %{"error_code" => error_code}} = Network.rename(@network_name, @network_name)
#   assert error_code == 404
# end
#
# end
