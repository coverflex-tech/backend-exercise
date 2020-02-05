defmodule Backend.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :price, :integer

      timestamps(updated_at: false)
    end

    create unique_index(:products, [:id])
  end
end
