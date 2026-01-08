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
end
