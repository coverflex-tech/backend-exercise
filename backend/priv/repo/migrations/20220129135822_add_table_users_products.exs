defmodule Benefits.Repo.Migrations.AddTableUsersProducts do
  use Ecto.Migration

  def change do
    create table(:users_products, primary_key: false) do
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
      add(:product_id, references(:products, on_delete: :delete_all), primary_key: true)
    end

    create(index(:users_products, [:user_id]))
    create(index(:users_products, [:product_id]))

    create(
      unique_index(:users_products, [:user_id, :product_id],
        name: :user_id_product_id_unique_index
      )
    )
  end
end
