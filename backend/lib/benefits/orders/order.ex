defmodule Benefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Orders.OrderProduct
  alias Benefits.Users
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
    |> put_total()
    |> validate_length(:items, min: 1)
    |> validates_user_balance()
    |> validates_products_exist()
  end

  defp put_total(changeset) when changeset.valid? == false, do: changeset
  defp put_total(changeset) do
    case get_change(changeset, :items) do
      nil ->
        changeset

      items ->
        put_change(changeset, :total, Products.sum_product_price(items))
    end
  end

  def validates_user_balance(changeset) when changeset.valid? == false, do: changeset
  def validates_user_balance(changeset) do
    total = get_field(changeset, :total)
    user_id = get_field(changeset, :user_id)

    balance = Users.get_user!(user_id).balance

    case Decimal.compare(total, balance) do
      :gt ->
        changeset
        |> add_error(:base, "insufficient_balance")

      _ ->
        changeset
    end
  end

  def validates_products_exist(changeset) when changeset.valid? == false, do: changeset
  def validates_products_exist(changeset) do
    items = get_field(changeset, :items)

    case Products.exists?(items) do
      false ->
        changeset
        |> add_error(:base, "products_not_found")

      _ ->
        changeset
    end
  end
end
