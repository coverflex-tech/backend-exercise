defmodule Backend.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :string_id, :string
      add :name, :string
      add :price, :integer

      timestamps()
    end

    create unique_index(:products, [:string_id])
  end
end
