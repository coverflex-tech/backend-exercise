defmodule CompanyBenefits.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    belongs_to(:user, CompanyBenefits.Accounts.User)

    many_to_many(
      :products,
      CompanyBenefits.Products.Product,
      join_through: CompanyBenefits.OrdersProducts.OrdersProducts,
      on_delete: :delete_all,
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
    |> put_assoc(:products, Map.get(attrs, :products, Map.get(order, :products, [])))
    |> validate_length(:products, min: 1)
  end
end
