defmodule Benefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Users.User
  alias Benefits.Products.Product

  schema "orders" do
    belongs_to :user, User
    has_many :items, Product

    timestamps()
  end

  @doc false
  def changeset(order) do
    order
    |> cast_assoc(:user, with: &User.changeset/2)
    |> cast_assoc(:items, with: &Product.changeset/2)
  end
end
