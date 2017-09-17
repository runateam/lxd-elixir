defmodule ProfileTest do
  use ExUnit.Case, async: false
  alias LXD.Profile

  @profile_name "elixir-test"
  @profile_cfg %{
    "name" => @profile_name,
    "description" => "elixir test"
  }

  setup context do
    if context[:create] do
      Profile.remove(@profile_name)
      Profile.create(@profile_cfg)
    end

    if context[:remove] do
      on_exit fn -> Profile.remove(@profile_name) end
    end

    :ok
  end

  @tag :remove
  test "create" do
    {:ok, _, %{"status_code" => status_code}} = Profile.create(@profile_cfg)
    assert status_code == 200
  end

  @tag :create
  test "remove" do
    {:ok, _, %{"status_code" => status_code}} = Profile.remove(@profile_name)
    assert status_code == 200
  end

  test "all" do
    {:ok, _, %{"status_code" => status_code}} = Profile.all
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "info" do
    {:ok, _, %{"status_code" => status_code}} = Profile.info(@profile_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "replace" do
    {:ok, _, %{"status_code" => status_code}} = Profile.replace(@profile_name, %{"description" => "a"})
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "update" do
    {:ok, _, %{"status_code" => status_code}} = Profile.update(@profile_name, %{"description" => "a"})
    assert status_code == 200
  end

  @tag :create
  test "rename" do
    new_name = @profile_name <> "-renamed"
    {:ok, _, %{"status_code" => status_code}} = Profile.rename(@profile_name, new_name)
    assert status_code == 200
    {:ok, _, %{"status_code" => status_code}} = Profile.remove(new_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "rename with same" do
    {:ok, _, %{"error_code" => error_code}} = Profile.rename(@profile_name, @profile_name)
    assert error_code == 409
  end

end
