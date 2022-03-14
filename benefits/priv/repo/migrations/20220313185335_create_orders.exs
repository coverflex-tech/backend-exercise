defmodule Benefits.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table("orders") do
      add :user_id, references(:users)
      add :price, :integer

      timestamps()
    end

    create index("orders", [:user_id])
    create constraint("orders", :price_must_be_positive, check: "price > 0")
  end
end
