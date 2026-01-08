defmodule Sirbiz.CRMTest do
  use Sirbiz.DataCase

  alias Sirbiz.CRM

  describe "profiles" do
    alias Sirbiz.CRM.Profile

    import Sirbiz.CRMFixtures

    @invalid_attrs %{first_name: nil, last_name: nil, phone: nil, birthdate: nil}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert CRM.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert CRM.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name", phone: "some phone", birthdate: ~D[2026-01-05]}

      assert {:ok, %Profile{} = profile} = CRM.create_profile(valid_attrs)
      assert profile.first_name == "some first_name"
      assert profile.last_name == "some last_name"
      assert profile.phone == "some phone"
      assert profile.birthdate == ~D[2026-01-05]
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CRM.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name", phone: "some updated phone", birthdate: ~D[2026-01-06]}

      assert {:ok, %Profile{} = profile} = CRM.update_profile(profile, update_attrs)
      assert profile.first_name == "some updated first_name"
      assert profile.last_name == "some updated last_name"
      assert profile.phone == "some updated phone"
      assert profile.birthdate == ~D[2026-01-06]
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = CRM.update_profile(profile, @invalid_attrs)
      assert profile == CRM.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = CRM.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> CRM.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = CRM.change_profile(profile)
    end
  end
end
