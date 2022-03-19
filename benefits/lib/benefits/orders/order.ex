defmodule Benefits.Orders.Order do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Benefits.User
  alias Benefits.Orders.Product

  schema "orders" do
    many_to_many(:products, Product, join_through: "order_products", unique: true)
    belongs_to(:user, User)

    field(:price, Money.Ecto.Amount.Type)

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs, products) do
    user
    |> cast(attrs, [:user_id, :price])
    |> validate_required([:user_id, :price])
    |> put_assoc(:products, products)
  end
end
