defmodule ContainerTest do
  use ExUnit.Case, async: false
  alias LXD.Container

  @container_name "elixir-test"
  @container_cfg %{
    "name" => @container_name,
    "source" => %{
      "type" => "image",
      "alias" => "elixir:1.5.1"
    }
  }

  setup context do
    if context[:create] do
      Container.remove(@container_name)
      Container.create(@container_cfg)
    end

    if context[:remove] do
      on_exit fn -> Container.remove(@container_name) end
    end

    :ok
  end

  @tag :remove
  test "create" do
    {:ok, _, %{"status_code" => status_code}} = Container.create(@container_cfg)
    assert status_code == 200
  end

  @tag :create
  test "remove" do
    {:ok, _, %{"status_code" => status_code}} = Container.remove(@container_name)
    assert status_code == 200
  end

  test "all" do
    {:ok, _, %{"status_code" => status_code}} = Container.all
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "info" do
    {:ok, _, %{"status_code" => status_code}} = Container.info(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "replace" do
    {:ok, _, %{"status_code" => status_code}} = Container.replace(@container_name, %{"description" => "a"})
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "update" do
    {:ok, _, %{"status_code" => status_code}} = Container.update(@container_name, %{"description" => "a"})
    assert status_code == 200
  end

  @tag :create
  test "rename" do
    new_name = @container_name <> "-renamed"
    {:ok, _, %{"status_code" => status_code}} = Container.rename(@container_name, new_name)
    assert status_code == 200
    {:ok, _, %{"status_code" => status_code}} = Container.remove(new_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "rename with same" do
    {:ok, _, %{"error_code" => error_code}} = Container.rename(@container_name, @container_name)
    assert error_code == 409
  end

  @tag :create
  @tag :remove
  test "state" do
    {:ok, _, %{"status_code" => status_code}} = Container.state(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "status" do
    {:ok, status} = Container.status(@container_name)
    assert status == "Stopped"
  end

  @tag :create
  @tag :remove
  test "start" do
    {:ok, _, %{"status_code" => status_code}} = Container.start(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "stop" do
    {:ok, _, %{"status_code" => status_code}} = Container.stop(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "restart" do
    {:ok, _, %{"status_code" => status_code}} = Container.restart(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "freeze" do
    {:ok, _, %{"status_code" => status_code}} = Container.freeze(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "unfreeze" do
    {:ok, _, %{"status_code" => status_code}} = Container.unfreeze(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "metadata" do
    {:ok, _, %{"status_code" => status_code}} = Container.metadata(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "template all" do
    {:ok, _, %{"status_code" => status_code}} = Container.Template.all(@container_name)
    assert status_code == 200
  end

  @tag :create
  @tag :remove
  test "log all" do
    {:ok, _, %{"status_code" => status_code}} = Container.Log.all(@container_name)
    assert status_code == 200
  end

end
