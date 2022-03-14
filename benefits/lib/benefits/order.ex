defmodule Benefits.Order do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Benefits.{Product, User}

  schema "orders" do
    many_to_many(:products, Product, join_through: "order_products")
    belongs_to(:user, User)

    field(:price, Money.Ecto.Amount.Type)

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
