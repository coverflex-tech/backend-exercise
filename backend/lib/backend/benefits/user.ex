defmodule Backend.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Benefits.{Order, Product}

  schema "users" do
    field :balance, :integer
    field :username, :string

    has_many :orders, Order
    many_to_many :products, Product, join_through: "ordered_products"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :balance])
    |> validate_required([:username, :balance])
    |> unique_constraint(:username)
  end
end
