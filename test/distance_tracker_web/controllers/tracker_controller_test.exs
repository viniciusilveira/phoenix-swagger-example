defmodule DistanceTrackerWeb.TrackerControllerTest do
  use DistanceTrackerWeb.ConnCase

  alias DistanceTracker.Trackers
  alias DistanceTracker.Trackers.Tracker

  @create_attrs %{
    activity: "some activity",
    completed_at: "2010-04-17T14:00:00Z",
    distance: 42
  }
  @update_attrs %{
    activity: "some updated activity",
    completed_at: "2011-05-18T15:01:01Z",
    distance: 43
  }
  @invalid_attrs %{activity: nil, completed_at: nil, distance: nil}

  def fixture(:tracker) do
    {:ok, tracker} = Trackers.create_tracker(@create_attrs)
    tracker
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all trackers", %{conn: conn} do
      conn = get(conn, Routes.tracker_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tracker" do
    test "renders tracker when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tracker_path(conn, :create), tracker: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tracker_path(conn, :show, id))

      assert %{
               "id" => id,
               "activity" => "some activity",
               "completed_at" => "2010-04-17T14:00:00Z",
               "distance" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tracker_path(conn, :create), tracker: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tracker" do
    setup [:create_tracker]

    test "renders tracker when data is valid", %{conn: conn, tracker: %Tracker{id: id} = tracker} do
      conn = put(conn, Routes.tracker_path(conn, :update, tracker), tracker: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tracker_path(conn, :show, id))

      assert %{
               "id" => id,
               "activity" => "some updated activity",
               "completed_at" => "2011-05-18T15:01:01Z",
               "distance" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tracker: tracker} do
      conn = put(conn, Routes.tracker_path(conn, :update, tracker), tracker: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tracker" do
    setup [:create_tracker]

    test "deletes chosen tracker", %{conn: conn, tracker: tracker} do
      conn = delete(conn, Routes.tracker_path(conn, :delete, tracker))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tracker_path(conn, :show, tracker))
      end
    end
  end

  defp create_tracker(_) do
    tracker = fixture(:tracker)
    {:ok, tracker: tracker}
  end
end
