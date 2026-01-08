defmodule Sirbiz.CRM.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :birthdate, :date
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:first_name, :last_name, :phone, :birthdate])
    |> validate_required([:first_name, :last_name])
  end
end
