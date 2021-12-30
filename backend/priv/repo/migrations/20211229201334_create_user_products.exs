defmodule Coverflex.Benefits.Repo.Migrations.CreateUserProducts do
  use Ecto.Migration

  def change do
    create table(:user_products) do
      add :user_id, references(:users, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:user_products, [:user_id])
    create index(:user_products, [:product_id])
  end
end
