defmodule Benefits.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:user_id, :balance]

  schema "users" do
    field :user_id, :string
    field :balance, :float

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint(:user_id)
  end
end
