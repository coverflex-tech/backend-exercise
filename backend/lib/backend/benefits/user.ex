defmodule Backend.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :string, autogenerate: false}
  schema "users" do
    field :balance, :integer, default: 500

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
