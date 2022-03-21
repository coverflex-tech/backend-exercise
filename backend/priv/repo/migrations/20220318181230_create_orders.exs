defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :total, :decimal

      add :user_id, references(:users, type: :string, column: :id), null: false
      timestamps()
    end
  end
end
