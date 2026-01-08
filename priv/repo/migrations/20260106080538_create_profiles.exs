defmodule Sirbiz.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :first_name, :string
      add :last_name, :string
      add :phone, :string
      add :birthdate, :date
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:profiles, [:user_id])
  end
end
