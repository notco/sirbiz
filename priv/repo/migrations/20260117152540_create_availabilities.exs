defmodule Sirbiz.Repo.Migrations.CreateAvailabilities do
  use Ecto.Migration

  def change do
    create table(:availabilities) do
      add :provider_id, references(:profiles, on_delete: :nothing), null: false
      add :venue_id, references(:venues, on_delete: :nothing), null: false
      add :day_of_week, :integer
      add :start_time, :time, null: false
      add :end_time, :time, null: false
      add :is_recurring, :boolean, default: true, null: false
      add :specific_date, :date
      add :deleted_at, :utc_datetime
      add :activated_at, :utc_datetime
      add :deactivated_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:availabilities, [:provider_id])
    create index(:availabilities, [:venue_id])
    create index(:availabilities, [:day_of_week])
    create index(:availabilities, [:specific_date])

    create constraint(:availabilities, :one_time_requires_date,
      check: "is_recurring = true OR specific_date IS NOT NULL"
    )
  end
end
