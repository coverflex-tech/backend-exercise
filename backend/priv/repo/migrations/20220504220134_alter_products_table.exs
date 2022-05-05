defmodule Backend.Repo.Migrations.AlterProductsTable do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :order_id, references(:orders)
    end
  end
end
