defmodule Benefits.Orders.Product do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "products" do
    field(:name, :string)
    field(:price, Money.Ecto.Amount.Type)

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
