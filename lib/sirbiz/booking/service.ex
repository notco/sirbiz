defmodule Sirbiz.Booking.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :name, :string
    field :description, :string
    field :duration_minutes, :integer
    field :is_active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs, user_scope) do
    service
    |> cast(attrs, [:name, :description, :duration_minutes, :is_active])
    |> validate_required([:name, :description, :duration_minutes, :is_active])
    |> put_change(:user_id, user_scope.user.id)
  end
end
