defmodule Benefits.Repo.Migrations.AddOrdersTable do
  use Ecto.Migration

  def up do
    create table("orders", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :string, null: false
      add :total_price, :integer, null: false
      add :products, {:array, :jsonb}, null: false

      timestamps()
    end
  end

  def down do
    drop table("orders")
  end
end
