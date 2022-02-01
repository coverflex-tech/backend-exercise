defmodule Benefits.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      add :total, :float, default: 0.00

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create index(:orders, [:user_id])
    create constraint(:orders, :total_must_be_non_negative, check: "total >= 0.00")
  end
end
