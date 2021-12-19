defmodule Benefits.Products.Inputs.CreateProductInput do
  @moduledoc """
  Input for creating products
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required [
    :name,
    :price
  ]

  @primary_key false
  embedded_schema do
    field :name, :string
    field :price, :float
  end

  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
