defmodule Benefits.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :codename, :string
      add :price, :decimal

      timestamps()
    end

    create index(:products, :codename, unique: true)
  end
end
