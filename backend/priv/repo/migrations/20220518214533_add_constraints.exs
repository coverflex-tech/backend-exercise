defmodule Benefits.Repo.Migrations.AddConstraints do
  use Ecto.Migration

  def change do
    create constraint(:users, "balance_must_be_non_negative", check: "balance >= 0")
    create constraint(:products, "price_must_be_non_negative", check: "price >= 0")

  end
end
