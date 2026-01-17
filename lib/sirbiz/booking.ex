defmodule Sirbiz.Booking do
  @moduledoc """
  The Booking context.
  """

  import Ecto.Query, warn: false
  alias Sirbiz.Repo

  alias Sirbiz.Booking.Service
  alias Sirbiz.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any service changes.

  The broadcasted messages match the pattern:

    * {:created, %Service{}}
    * {:updated, %Service{}}
    * {:deleted, %Service{}}

  """
  def subscribe_services(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Sirbiz.PubSub, "user:#{key}:services")
  end

  defp broadcast_service(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Sirbiz.PubSub, "user:#{key}:services", message)
  end

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services(scope)
      [%Service{}, ...]

  """
  def list_services(%Scope{} = scope) do
    Repo.all_by(Service, user_id: scope.user.id)
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(scope, 123)
      %Service{}

      iex> get_service!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(%Scope{} = scope, id) do
    Repo.get_by!(Service, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(scope, %{field: value})
      {:ok, %Service{}}

      iex> create_service(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(%Scope{} = scope, attrs) do
    with {:ok, service = %Service{}} <-
           %Service{}
           |> Service.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_service(scope, {:created, service})
      {:ok, service}
    end
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(scope, service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(scope, service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Scope{} = scope, %Service{} = service, attrs) do
    true = service.user_id == scope.user.id

    with {:ok, service = %Service{}} <-
           service
           |> Service.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_service(scope, {:updated, service})
      {:ok, service}
    end
  end

  @doc """
  Deletes a service.

  ## Examples

      iex> delete_service(scope, service)
      {:ok, %Service{}}

      iex> delete_service(scope, service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Scope{} = scope, %Service{} = service) do
    true = service.user_id == scope.user.id

    with {:ok, service = %Service{}} <-
           Repo.delete(service) do
      broadcast_service(scope, {:deleted, service})
      {:ok, service}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(scope, service)
      %Ecto.Changeset{data: %Service{}}

  """
  def change_service(%Scope{} = scope, %Service{} = service, attrs \\ %{}) do
    true = service.user_id == scope.user.id

    Service.changeset(service, attrs, scope)
  end

  alias Sirbiz.Booking.Availability

  @doc """
  Returns the list of availabilities.

  ## Examples

      iex> list_availabilities()
      [%Availability{}, ...]

  """
  def list_availabilities do
    Repo.all(Availability)
  end

  @doc """
  Gets a single availability.

  Raises `Ecto.NoResultsError` if the Availability does not exist.

  ## Examples

      iex> get_availability!(123)
      %Availability{}

      iex> get_availability!(456)
      ** (Ecto.NoResultsError)

  """
  def get_availability!(id), do: Repo.get!(Availability, id)

  @doc """
  Creates a availability.

  ## Examples

      iex> create_availability(%{field: value})
      {:ok, %Availability{}}

      iex> create_availability(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_availability(attrs) do
    %Availability{}
    |> Availability.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a availability.

  ## Examples

      iex> update_availability(availability, %{field: new_value})
      {:ok, %Availability{}}

      iex> update_availability(availability, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_availability(%Availability{} = availability, attrs) do
    availability
    |> Availability.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a availability.

  ## Examples

      iex> delete_availability(availability)
      {:ok, %Availability{}}

      iex> delete_availability(availability)
      {:error, %Ecto.Changeset{}}

  """
  def delete_availability(%Availability{} = availability) do
    Repo.delete(availability)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking availability changes.

  ## Examples

      iex> change_availability(availability)
      %Ecto.Changeset{data: %Availability{}}

  """
  def change_availability(%Availability{} = availability, attrs \\ %{}) do
    Availability.changeset(availability, attrs)
  end
end
