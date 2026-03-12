defmodule LinkShortener.Repo.Migrations.CreateShortenings do
  use Ecto.Migration

  def change do
    create table(:shortenings) do
      add :slug, :string
      add :url, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:shortenings, [:slug])
  end
end
