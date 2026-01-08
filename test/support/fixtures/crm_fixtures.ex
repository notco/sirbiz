defmodule Sirbiz.CRMFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sirbiz.CRM` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        birthdate: ~D[2026-01-05],
        first_name: "some first_name",
        last_name: "some last_name",
        phone: "some phone"
      })
      |> Sirbiz.CRM.create_profile()

    profile
  end
end
