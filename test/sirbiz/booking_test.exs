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
end
