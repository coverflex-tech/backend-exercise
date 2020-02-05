defmodule Backend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :data, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:user_id])
  end
end
