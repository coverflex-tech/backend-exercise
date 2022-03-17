defmodule Benefits.Products.Product do
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @timestamps_opts [type: :naive_datetime_usec]

  @required_fields [:name, :price]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "products" do
    field(:name, :string)
    field(:price, :integer)

    timestamps()
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:price, greater_than: 0)
  end

  def as_order_product(data, %{id: id, name: name, price: price}) do
    data
    |> cast(%{id: id, name: name, price: price}, [:id, :name, :price])
    |> validate_required(@required_fields)
    |> validate_number(:price, greater_than: 0)
  end
end
