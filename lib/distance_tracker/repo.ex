defmodule DistanceTracker.Repo do
  use Ecto.Repo,
    otp_app: :distance_tracker,
    adapter: Ecto.Adapters.Postgres
end
