defmodule Coverflex.Benefits.Vallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vallets" do
    field :balance, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(vallet, attrs) do
    vallet
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end
