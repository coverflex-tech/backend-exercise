defmodule Benefits.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table("products", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :price, :integer

      timestamps()

    end

    create constraint("products", :price_must_be_positive, check: "price > 0")
  end
end
