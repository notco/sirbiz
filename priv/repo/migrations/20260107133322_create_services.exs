defmodule Sirbiz.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :description, :text
      add :duration_minutes, :integer
      add :is_active, :boolean, default: false, null: false
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:services, [:user_id])
  end
end
