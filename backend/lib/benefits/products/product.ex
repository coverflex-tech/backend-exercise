defmodule Benefits.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:name, :price]

  schema "products" do
    field :name, :string
    field :price, :float

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
