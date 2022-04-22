defmodule Backend.Repo.Migrations.CreateBenefits do
  use Ecto.Migration

  def change do
    create table(:benefits) do
      add :user_id, references(:users, column: :user_id, type: :string, on_delete: :delete_all)
      add :order_id, references(:orders, on_delete: :delete_all)
      add :product_id, references(:products, type: :varchar, on_delete: :delete_all)

      timestamps()
    end

    create index(:benefits, [:order_id])
    create unique_index(:benefits, [:user_id, :product_id])
  end
end
