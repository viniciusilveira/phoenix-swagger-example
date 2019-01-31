defmodule DistanceTracker.Trackers.Tracker do
  use Ecto.Schema
  import Ecto.Changeset


  schema "trackers" do
    field :activity, :string
    field :completed_at, :utc_datetime
    field :distance, :integer

    timestamps()
  end

  @doc false
  def changeset(tracker, attrs) do
    tracker
    |> cast(attrs, [:distance, :activity, :completed_at])
    |> validate_required([:distance, :activity, :completed_at])
  end
end
