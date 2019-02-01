defmodule DistanceTrackerWeb.Router do
  use DistanceTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DistanceTrackerWeb do
    pipe_through :api

    resources "/trackers", TrackerController, except: [:new, :edit]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :distance_tracker, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "0.0.1",
        title: "Distance Tracker App"
      }
    }
  end
end
