defmodule Benefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Repo
  alias Benefits.Users.User
  alias Benefits.Products.Product

  schema "orders" do
    belongs_to :user, User
    many_to_many :items, Product, join_through: "orders_products"

    timestamps()
  end

  @doc false
  def changeset(order \\ %__MODULE__{}, params) do
    order
    |> Repo.preload([:user, :items])
    |> cast(params, [])
    |> put_assoc(:user, params.user)
    |> put_assoc(:items, params.items)
  end
end
