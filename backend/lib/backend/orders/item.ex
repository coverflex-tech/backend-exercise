defmodule Backend.Orders.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Orders.Order

  @allowed_fields [:order_id, :user_id, :product_id, :price]

  schema "items" do
    field(:price, :integer)
    field(:user_id, :string)
    field(:product_id, :string)

    belongs_to(:order, Order)

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:price])
    |> validate_required([:price])
    |> unique_constraint([:user_id, name: :items_user_id_product_id_index])
  end
end
