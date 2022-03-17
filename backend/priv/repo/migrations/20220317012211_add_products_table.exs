defmodule Benefits.Repo.Migrations.AddProductsTable do
  use Ecto.Migration

  def up do
    create table("products", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :price, :integer, null: false

      timestamps()
    end
  end

  def down do
    drop table("products")
  end
end
