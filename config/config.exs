# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :distance_tracker,
  ecto_repos: [DistanceTracker.Repo]

# Configures the endpoint
config :distance_tracker, DistanceTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v6rsJr8lAyFBZPiZ76FP2+KO8gxynHDrHMhtjF9QmYSJGWQeq77cTf+TZbeymxBS",
  render_errors: [view: DistanceTrackerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DistanceTracker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
