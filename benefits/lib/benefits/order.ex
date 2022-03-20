defmodule Benefits.Order do
  @moduledoc "The struct that represents an order"

  use Ecto.Schema

  import Ecto.Changeset

  alias Benefits.Product
  alias Benefits.User

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
