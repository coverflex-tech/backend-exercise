defmodule Benefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.OrderProduct
  alias Benefits.Users.User
  alias Benefits.Products
  alias Benefits.Products.Product

  schema "orders" do
    field :total, :decimal, default: Decimal.new("0")

    belongs_to :user, User, type: :string, references: :user_id
    many_to_many :products, Product, join_through: OrderProduct

    field :items, {:array, :integer}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :total, :items])
    |> validate_required([:user_id, :items])
    |> validate_length(:items, min: 1)
    |> calculate_total()
    |> foreign_key_constraint(:user_id)
  end

  defp calculate_total(changeset) when changeset.valid? == false, do: changeset

  defp calculate_total(changeset) do
    items = get_change(changeset, :items)
    put_change(changeset, :total, Products.sum_product_price(items))
  end
end
