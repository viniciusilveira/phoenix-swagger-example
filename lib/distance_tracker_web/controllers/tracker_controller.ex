defmodule DistanceTrackerWeb.TrackerController do
  use DistanceTrackerWeb, :controller
  use PhoenixSwagger

  alias DistanceTracker.Trackers
  alias DistanceTracker.Trackers.Tracker

  action_fallback DistanceTrackerWeb.FallbackController

  def swagger_definitions do
    %{
      Tracker: swagger_schema do
        title "Tracker"
        description "An activity which has been recorded"
        properties do
        id :string, "The ID of the activity"
        activity :string, "The activity recorded", required: true
        distance :integer, "How far travelled", required: true
        completed_at :string, "When was the activity completed", format: "ISO-8601"
        inserted_at :string, "When was the activity initially inserted", format: "ISO-8601"
        updated_at :string, "When was the activity last updated", format: "ISO-8601"
      end
        example %{
          completed_at: "2017-03-21T14:00:00Z",
          activity: "climbing",
          distance: 150
        }
      end,
      Trackers: swagger_schema do
        title "Trackers"
        description "All activities that have been recorded"
        type :array
        items Schema.ref(:Tracker)
      end,
      Error: swagger_schema do
        title "Errors"
        description "Error responses from the API"
        properties do
          error :string, "The message of the error raised", required: true
        end
      end
    }
  end

  swagger_path :index do
    get "/api/trackers"
    summary "List all recorded activities"
    description "List all recorded activities"
    response 200, "Ok", Schema.ref(:Trackers)
  end
  def index(conn, _params) do
    trackers = Trackers.list_trackers()
    render(conn, "index.json", trackers: trackers)
  end

  swagger_path :create do
    post "/api/trackers"
    summary "Add a new activity"
    description "Record a new activity which has been completed"
    parameters do
      tracker :body, Schema.ref(:Tracker), "Activity to record", required: true
    end
    response 201, "Ok", Schema.ref(:Tracker)
    response 422, "Unprocessable Entity", Schema.ref(:Error)
  end
  def create(conn, %{"tracker" => tracker_params}) do
    with {:ok, %Tracker{} = tracker} <- Trackers.create_tracker(tracker_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tracker_path(conn, :show, tracker))
      |> render("show.json", tracker: tracker)
    end
  end

  swagger_path :show do
    get "/api/trackers/{id}"
    summary "Retrieve an activity"
    description "Retrieve an activity that you have recorded"
    parameters do
      id :path, :string, "The uuid of the activity", required: true
    end
    response 200, "Ok", Schema.ref(:Tracker)
    response 404, "Not found", Schema.ref(:Error)
  end
  def show(conn, %{"id" => id}) do
    tracker = Trackers.get_tracker!(id)
    render(conn, "show.json", tracker: tracker)
  end

  swagger_path :update do
    patch "/api/trackers/{id}"
    summary "Update an existing activity"
    description "Record changes to a completed activity"
    parameters do
      id :path, :string, "The uuid of the activity", required: true
      tracker :body, Schema.ref(:Tracker), "The activity details to update"
    end
    response 201, "Ok", Schema.ref(:Tracker)
    response 422, "Unprocessable Entity", Schema.ref(:Error)
  end
  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Trackers.get_tracker!(id)

    with {:ok, %Tracker{} = tracker} <- Trackers.update_tracker(tracker, tracker_params) do
      render(conn, "show.json", tracker: tracker)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/trackers/{id}"
    summary "Delete an activity"
    description "Remove an activity from the system"
    parameters do
      id :path, :string, "The uuid of the activity", required: true
    end
    response 204, "No content"
    response 404, "Not found", Schema.ref(:Error)
  end
  def delete(conn, %{"id" => id}) do
    tracker = Trackers.get_tracker!(id)

    with {:ok, %Tracker{}} <- Trackers.delete_tracker(tracker) do
      send_resp(conn, :no_content, "")
    end
  end
end
