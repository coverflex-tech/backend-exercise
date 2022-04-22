defmodule Backend.Benefits.Benefit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "benefits" do
    belongs_to :order, Backend.Benefits.Order
    belongs_to :user, Backend.Benefits.User, type: :string, references: :user_id
    belongs_to :product, Backend.Benefits.Product, type: :string

    timestamps()
  end

  @doc false
  def changeset(benefit, attrs) do
    benefit
    |> cast(attrs, [])
    |> validate_required([])
  end
end
