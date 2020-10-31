defmodule CompanyBenefits.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:identifier, :string)
    field(:name, :string)
    field(:price, :float, default: 0)

    many_to_many(:orders, CompanyBenefits.Orders.Order,
      join_through: CompanyBenefits.OrdersProducts.OrdersProducts,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:identifier, :name, :price])
    |> validate_required([:identifier, :name])
    |> unique_constraint(:identifier)
  end
end
