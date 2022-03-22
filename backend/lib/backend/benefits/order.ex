defmodule Backend.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Benefits.User

  schema "orders" do
    field :total_value, :integer

    belongs_to :users, User

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_value])
    |> validate_required([:total_value])
  end
end
