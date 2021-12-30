defmodule Coverflex.Benefits.UserProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_products" do

    field :user_id, :id
    field :product_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_product, attrs) do
    user_product
    |> cast(attrs, [])
    |> validate_required([])
  end
end
