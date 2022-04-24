defmodule Backend.Benefits.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "products" do
    field :name, :string
    field :price, :integer

    many_to_many :users, Backend.Benefits.User,
      join_through: Backend.Benefits.Benefit,
      join_keys: [product_id: :id, user_id: :user_id],
      unique: true

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:id, :name, :price])
    |> validate_required([:id, :name, :price])
    |> unique_constraint(:name)
  end
end
