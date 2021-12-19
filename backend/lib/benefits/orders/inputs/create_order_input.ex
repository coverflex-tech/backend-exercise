defmodule Benefits.Orders.Inputs.CreateOrderInput do
  @moduledoc """
  Input for creating orders
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required [
    :username,
    :items
  ]

  @primary_key false
  embedded_schema do
    field :username, :string
    field :items, {:array, :string}
  end

  def changeset(module \\ %__MODULE__{}, params) do
    module
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
