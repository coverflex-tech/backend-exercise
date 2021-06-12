defmodule Coverflex.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:price, :integer, default: 0)

      timestamps()
    end

    create(constraint(:products, :price_must_be_greater_than_or_equal_zero, check: "price >= 0"))
  end
end
