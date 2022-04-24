defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, references(:users, column: :user_id, type: :string, on_delete: :delete_all)
      add :total, :integer, default: 0

      timestamps()
    end

    create index(:orders, [:user_id])
  end
end
