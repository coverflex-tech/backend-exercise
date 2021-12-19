defmodule Benefits.Repo.Migrations.AddOrderIdToProducts do
  use Ecto.Migration

  def change do
    alter table :products do
      add :order_id, references :orders
    end

    create index :products, [:order_id]
  end
end
