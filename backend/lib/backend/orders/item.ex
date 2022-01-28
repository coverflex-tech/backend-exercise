defmodule Backend.Orders.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Orders.Order

  schema "items" do
    field(:price, :integer)
    # field(:order_id, :id)
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
