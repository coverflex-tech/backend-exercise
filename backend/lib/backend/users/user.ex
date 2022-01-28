defmodule Backend.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :string, []}
  @derive {Phoenix.Param, key: :user_id}
  schema "users" do
    field(:balance, :integer)

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
