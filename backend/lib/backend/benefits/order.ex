defmodule Backend.Benefits.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    belongs_to :user, Backend.Benefits.User, type: :string, references: :user_id
    has_many :benefits, Backend.Benefits.Benefit
    field :total, :integer

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total])
    |> validate_required([:total])
  end
end
