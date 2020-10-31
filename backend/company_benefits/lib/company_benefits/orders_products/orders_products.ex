defmodule CompanyBenefits.OrdersProducts.OrdersProducts do
  use Ecto.Schema
  import Ecto.Changeset

  alias CompanyBenefits.Orders.Order
  alias CompanyBenefits.Products.Product

  schema "orders_products" do
    belongs_to(:order, Order)
    belongs_to(:product, Product)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:product_id)
    |> unique_constraint(:orders_products)
  end
end
