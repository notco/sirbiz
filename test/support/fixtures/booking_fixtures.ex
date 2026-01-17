defmodule Sirbiz.BookingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sirbiz.Booking` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        duration_minutes: 42,
        is_active: true,
        name: "some name"
      })

    {:ok, service} = Sirbiz.Booking.create_service(scope, attrs)
    service
  end

  @doc """
  Generate a availability.
  """
  def availability_fixture(attrs \\ %{}) do
    {:ok, availability} =
      attrs
      |> Enum.into(%{
        activated_at: ~U[2026-01-16 15:24:00Z],
        day_of_week: 42,
        deactivated_at: ~U[2026-01-16 15:24:00Z],
        deleted_at: ~U[2026-01-16 15:24:00Z],
        end_time: ~T[14:00:00],
        is_recurring: true,
        specific_date: ~D[2026-01-16],
        start_time: ~T[14:00:00]
      })
      |> Sirbiz.Booking.create_availability()

    availability
  end
end
