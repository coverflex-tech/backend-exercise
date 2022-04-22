defmodule Backend.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Backend.Benefits.{Benefit, Product, User}

  schema "orders" do
    belongs_to :user, User, type: :string, references: :user_id
    has_many :benefits, Benefit
    field :total, :integer

    timestamps()
  end

  @doc false
  def changeset(order, attrs = %{"items" => products}) do
    total =
      Product
      |> where([purchased_product], purchased_product.id in ^products)
      |> Backend.Repo.aggregate(:sum, :price)

    order
    |> cast(attrs, [:user_id])
    |> change(total: total)
  end
end
