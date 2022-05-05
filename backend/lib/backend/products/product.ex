defmodule Backend.Products.Product do
  use Ecto.Schema

  import Ecto.SoftDelete.Schema

  alias Backend.Orders.Order

  @primary_key {:id, :string, autogenerate: false}

  schema "products" do
    field :name, :string
    field :price, :decimal

    belongs_to :order, Order

    timestamps()
    soft_delete_schema()
  end
end
