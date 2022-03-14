defmodule Benefits.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table("orders", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :price, :integer

      timestamps()
    end

    create index("orders", [:user_id])
    create constraint("orders", :price_must_be_positive, check: "price > 0")
  end
end
