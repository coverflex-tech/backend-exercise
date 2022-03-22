defmodule Backend.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :integer
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :balance])
    |> validate_required([:username, :balance])
    |> unique_constraint(:username)
  end
end
