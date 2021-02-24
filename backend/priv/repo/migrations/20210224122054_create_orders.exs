defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :order_id, :uuid, primary_key: true
      add :data, :map
    end
  end
end
