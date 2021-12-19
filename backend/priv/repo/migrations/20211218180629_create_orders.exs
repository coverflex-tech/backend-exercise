defmodule Benefits.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table :orders do
      add :user_id, references :users

      timestamps()
    end

    create index :orders, [:user_id]
  end
end
