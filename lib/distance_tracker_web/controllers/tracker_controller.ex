defmodule DistanceTrackerWeb.TrackerController do
  use DistanceTrackerWeb, :controller

  alias DistanceTracker.Trackers
  alias DistanceTracker.Trackers.Tracker

  action_fallback DistanceTrackerWeb.FallbackController

  def index(conn, _params) do
    trackers = Trackers.list_trackers()
    render(conn, "index.json", trackers: trackers)
  end

  def create(conn, %{"tracker" => tracker_params}) do
    with {:ok, %Tracker{} = tracker} <- Trackers.create_tracker(tracker_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tracker_path(conn, :show, tracker))
      |> render("show.json", tracker: tracker)
    end
  end

  def show(conn, %{"id" => id}) do
    tracker = Trackers.get_tracker!(id)
    render(conn, "show.json", tracker: tracker)
  end

  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Trackers.get_tracker!(id)

    with {:ok, %Tracker{} = tracker} <- Trackers.update_tracker(tracker, tracker_params) do
      render(conn, "show.json", tracker: tracker)
    end
  end

  def delete(conn, %{"id" => id}) do
    tracker = Trackers.get_tracker!(id)

    with {:ok, %Tracker{}} <- Trackers.delete_tracker(tracker) do
      send_resp(conn, :no_content, "")
    end
  end
end
