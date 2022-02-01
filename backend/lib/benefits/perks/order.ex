defmodule Benefits.Perks.Order do
  @moduledoc """
  Orderr struct and schema to persist in the data store.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Benefits.Accounts.User
  alias Benefits.Perks.{OrderLine, Product}

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "orders" do
    field :total, :float

    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    many_to_many :products, Product, join_through: OrderLine

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, [:user_id, :total])
    |> validate_required([:user_id, :total])
    |> foreign_key_constraint(:user_id)
    |> check_constraint(:total,
      name: :total_must_be_non_negative,
      message: "Total must be non-negative"
    )
  end
end
