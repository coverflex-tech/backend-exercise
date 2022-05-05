defmodule Backend.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  import Ecto.SoftDelete.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :price, :decimal, null: false

      timestamps()
      soft_delete_columns()
    end
  end
end
