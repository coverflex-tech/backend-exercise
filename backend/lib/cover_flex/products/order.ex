defmodule CoverFlex.Products.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias CoverFlex.Accounts
  alias CoverFlex.Accounts.User
  alias CoverFlex.Products
  alias CoverFlex.Products.Product

  schema "orders" do
    field :total, :integer
    belongs_to :user, User, type: :string
    many_to_many :products, Product, join_through: "products_orders"

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [])
    |> associate_user(attrs)
    |> associate_products(attrs)
    |> validate_no_duplicate_products(attrs)
    |> associate_product_total(attrs)
    |> validate_enough_balance(attrs)
    |> validate_required([:total, :user, :products])
  end

  defp associate_user(changeset, attrs) do
    user_id = Map.get(attrs, :user_id)
    user = Accounts.ensure_user(user_id)

    changeset
    |> put_assoc(:user, user)
  end

  defp associate_products(changeset, attrs) do
    product_ids = Map.get(attrs, :product_ids)
    products = Enum.map(product_ids, fn p_id ->
      case Products.get_product(p_id) do
        {:ok, product} -> product
        {:error, :not_found} -> nil
      end
    end)

    changeset
    |> put_assoc(:products, products)
  end

  defp associate_product_total(changeset, _attrs) do
    products = get_field(changeset, :products)
    total = Products.totalize_products(products)

    changeset
    |> put_change(:total, total)
  end

  defp validate_no_duplicate_products(changeset, attrs) do
    user_id = Map.get(attrs, :user_id)
    product_id_set = MapSet.new(Map.get(attrs, :product_ids))
    purchased_product_id_set = MapSet.new(Products.get_user_products(user_id))

    diff = MapSet.intersection(product_id_set, purchased_product_id_set)

    if MapSet.size(diff) == 0 do
      changeset
    else
      changeset
      |> add_error(:products, "products already purchased")
    end
  end

  defp validate_enough_balance(changeset, _attrs) do
    total = get_field(changeset, :total)
    user = get_field(changeset, :user)

    if user.balance < total do
      changeset
      |> add_error(:total, "insufficient balance")
    else
      changeset
    end
  end
end
