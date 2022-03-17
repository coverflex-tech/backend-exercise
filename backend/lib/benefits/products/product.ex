defmodule Benefits.Products.Product do
  @moduledoc """
  Schema for a product
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @timestamps_opts [type: :naive_datetime_usec]

  @required_fields [:id, :name, :price]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "products" do
    field(:name, :string)
    field(:price, :integer)

    timestamps()
  end

  def cast_as_order_product(data, %__MODULE__{id: id, name: name, price: price}) do
    data
    |> cast(%{id: id, name: name, price: price}, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:price, greater_than: 0)
  end
end
