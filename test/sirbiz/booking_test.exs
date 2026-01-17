defmodule Sirbiz.BookingTest do
  use Sirbiz.DataCase

  alias Sirbiz.Booking

  describe "services" do
    alias Sirbiz.Booking.Service

    import Sirbiz.AccountsFixtures, only: [user_scope_fixture: 0]
    import Sirbiz.BookingFixtures

    @invalid_attrs %{name: nil, description: nil, duration_minutes: nil, is_active: nil}

    test "list_services/1 returns all scoped services" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      service = service_fixture(scope)
      other_service = service_fixture(other_scope)
      assert Booking.list_services(scope) == [service]
      assert Booking.list_services(other_scope) == [other_service]
    end

    test "get_service!/2 returns the service with given id" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      other_scope = user_scope_fixture()
      assert Booking.get_service!(scope, service.id) == service
      assert_raise Ecto.NoResultsError, fn -> Booking.get_service!(other_scope, service.id) end
    end

    test "create_service/2 with valid data creates a service" do
      valid_attrs = %{name: "some name", description: "some description", duration_minutes: 42, is_active: true}
      scope = user_scope_fixture()

      assert {:ok, %Service{} = service} = Booking.create_service(scope, valid_attrs)
      assert service.name == "some name"
      assert service.description == "some description"
      assert service.duration_minutes == 42
      assert service.is_active == true
      assert service.user_id == scope.user.id
    end

    test "create_service/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Booking.create_service(scope, @invalid_attrs)
    end

    test "update_service/3 with valid data updates the service" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description", duration_minutes: 43, is_active: false}

      assert {:ok, %Service{} = service} = Booking.update_service(scope, service, update_attrs)
      assert service.name == "some updated name"
      assert service.description == "some updated description"
      assert service.duration_minutes == 43
      assert service.is_active == false
    end

    test "update_service/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      service = service_fixture(scope)

      assert_raise MatchError, fn ->
        Booking.update_service(other_scope, service, %{})
      end
    end

    test "update_service/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Booking.update_service(scope, service, @invalid_attrs)
      assert service == Booking.get_service!(scope, service.id)
    end

    test "delete_service/2 deletes the service" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      assert {:ok, %Service{}} = Booking.delete_service(scope, service)
      assert_raise Ecto.NoResultsError, fn -> Booking.get_service!(scope, service.id) end
    end

    test "delete_service/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      service = service_fixture(scope)
      assert_raise MatchError, fn -> Booking.delete_service(other_scope, service) end
    end

    test "change_service/2 returns a service changeset" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      assert %Ecto.Changeset{} = Booking.change_service(scope, service)
    end
  end

  describe "availabilities" do
    alias Sirbiz.Booking.Availability

    import Sirbiz.BookingFixtures

    @invalid_attrs %{day_of_week: nil, start_time: nil, end_time: nil, is_recurring: nil, specific_date: nil, deleted_at: nil, activated_at: nil, deactivated_at: nil}

    test "list_availabilities/0 returns all availabilities" do
      availability = availability_fixture()
      assert Booking.list_availabilities() == [availability]
    end

    test "get_availability!/1 returns the availability with given id" do
      availability = availability_fixture()
      assert Booking.get_availability!(availability.id) == availability
    end

    test "create_availability/1 with valid data creates a availability" do
      valid_attrs = %{day_of_week: 42, start_time: ~T[14:00:00], end_time: ~T[14:00:00], is_recurring: true, specific_date: ~D[2026-01-16], deleted_at: ~U[2026-01-16 15:24:00Z], activated_at: ~U[2026-01-16 15:24:00Z], deactivated_at: ~U[2026-01-16 15:24:00Z]}

      assert {:ok, %Availability{} = availability} = Booking.create_availability(valid_attrs)
      assert availability.day_of_week == 42
      assert availability.start_time == ~T[14:00:00]
      assert availability.end_time == ~T[14:00:00]
      assert availability.is_recurring == true
      assert availability.specific_date == ~D[2026-01-16]
      assert availability.deleted_at == ~U[2026-01-16 15:24:00Z]
      assert availability.activated_at == ~U[2026-01-16 15:24:00Z]
      assert availability.deactivated_at == ~U[2026-01-16 15:24:00Z]
    end

    test "create_availability/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Booking.create_availability(@invalid_attrs)
    end

    test "update_availability/2 with valid data updates the availability" do
      availability = availability_fixture()
      update_attrs = %{day_of_week: 43, start_time: ~T[15:01:01], end_time: ~T[15:01:01], is_recurring: false, specific_date: ~D[2026-01-17], deleted_at: ~U[2026-01-17 15:24:00Z], activated_at: ~U[2026-01-17 15:24:00Z], deactivated_at: ~U[2026-01-17 15:24:00Z]}

      assert {:ok, %Availability{} = availability} = Booking.update_availability(availability, update_attrs)
      assert availability.day_of_week == 43
      assert availability.start_time == ~T[15:01:01]
      assert availability.end_time == ~T[15:01:01]
      assert availability.is_recurring == false
      assert availability.specific_date == ~D[2026-01-17]
      assert availability.deleted_at == ~U[2026-01-17 15:24:00Z]
      assert availability.activated_at == ~U[2026-01-17 15:24:00Z]
      assert availability.deactivated_at == ~U[2026-01-17 15:24:00Z]
    end

    test "update_availability/2 with invalid data returns error changeset" do
      availability = availability_fixture()
      assert {:error, %Ecto.Changeset{}} = Booking.update_availability(availability, @invalid_attrs)
      assert availability == Booking.get_availability!(availability.id)
    end

    test "delete_availability/1 deletes the availability" do
      availability = availability_fixture()
      assert {:ok, %Availability{}} = Booking.delete_availability(availability)
      assert_raise Ecto.NoResultsError, fn -> Booking.get_availability!(availability.id) end
    end

    test "change_availability/1 returns a availability changeset" do
      availability = availability_fixture()
      assert %Ecto.Changeset{} = Booking.change_availability(availability)
    end
  end
end
