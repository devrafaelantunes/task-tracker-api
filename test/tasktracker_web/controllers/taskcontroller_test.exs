defmodule TaskControllerTest do
  use TasktrackerWeb.ConnCase
  use ExUnit.Case, async: true

  alias TaskTracker.Internal, as: Internal
  alias TaskTracker.Model, as: Model

  @params %{task_name: "Testing",
    task_description: "TaskTracker",
    date: "10/05/2021",
    reminder: false,
    completed: false}

  @invalid_params %{task_description: "Testing",
  date: "10/10/2020"}


  describe "index" do
    test "listing all tasks", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create" do
    test "creating a task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task = @params)
      assert %{"task_id" => task_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.task_path(conn, :show, task_id))
      assert %{
        "task_id" => task_id,
        "task_name" => "Testing",
        "task_description" => "TaskTracker",
        "date" => "10/05/2021",
        "reminder" => false,
        "completed" => false
      }
    end

    test "creating a task when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task = @invalid_params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete" do
    test "delete a task", %{conn: conn} do
      assert {:ok, %Model{} = task} = Internal.create_task(@params)

      conn = delete(conn, Routes.task_path(conn, :delete, task.task_id))
      assert response(conn, 204)

    end
  end

end
