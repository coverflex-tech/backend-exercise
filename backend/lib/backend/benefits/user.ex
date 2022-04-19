defmodule Backend.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :integer
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :balance])
    |> validate_required([:user_id, :balance])
    |> unique_constraint(:user_id)
  end
end
