defmodule Backend.Users.Order do
  @moduledoc """
  Order model
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:order_id, :id, autogenerate: true}

  schema "orders" do
    field(:items, {:array, :string}, default: [])
    field(:total, :integer, default: 0)

    belongs_to(:user, Backend.Users.User, references: :user_id, type: :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:order_id, :items, :total])
  end
end
