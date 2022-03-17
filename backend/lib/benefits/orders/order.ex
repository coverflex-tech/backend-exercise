defmodule Benefits.Orders.Order do
  @moduledoc """
  Schema for product orders
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Benefits.Products.Product

  @type t() :: %__MODULE__{}

  @timestamps_opts [type: :naive_datetime_usec]

  @required_fields [:user_id, :total_price]

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "orders" do
    field(:user_id, :string)
    field(:total_price, :integer)

    embeds_many(:products, Product)

    timestamps()
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, @required_fields)
    |> cast_embed(:products, required: true, with: {Product, :as_order_product, []})
    |> validate_required(@required_fields)
  end
end
