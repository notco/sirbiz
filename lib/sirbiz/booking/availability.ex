defmodule Sirbiz.Booking.Availability do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sirbiz.CRM.{Profile, Venue}

  schema "availabilities" do
    field :day_of_week, :integer
    field :start_time, :time
    field :end_time, :time
    field :is_recurring, :boolean, default: true
    field :specific_date, :date
    field :deleted_at, :utc_datetime
    field :activated_at, :utc_datetime
    field :deactivated_at, :utc_datetime

    belongs_to :provider, Profile
    belongs_to :venue, Venue

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(availability, attrs) do
    availability
    |> cast(attrs, [
      :provider_id,
      :venue_id,
      :day_of_week,
      :start_time,
      :end_time,
      :is_recurring,
      :specific_date,
      :deleted_at,
      :activated_at,
      :deactivated_at
    ])
    |> validate_required([:provider_id, :venue_id, :start_time, :end_time])
    |> validate_day_of_week()
    |> validate_time_range()
    |> validate_one_time_override()
    |> foreign_key_constraint(:provider_id)
    |> foreign_key_constraint(:venue_id)
  end

  defp validate_day_of_week(changeset) do
    changeset
    |> validate_inclusion(:day_of_week, 0..6,
      message: "must be between 0 (Sunday) and 6 (Saturday)"
    )
  end

  defp validate_time_range(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    if start_time && end_time && Time.compare(start_time, end_time) != :lt do
      add_error(changeset, :end_time, "must be after start time")
    else
      changeset
    end
  end

  defp validate_one_time_override(changeset) do
    is_recurring = get_field(changeset, :is_recurring)
    specific_date = get_field(changeset, :specific_date)

    if is_recurring == false && is_nil(specific_date) do
      add_error(changeset, :specific_date, "must be set for one-time overrides")
    else
      changeset
    end
  end
end
