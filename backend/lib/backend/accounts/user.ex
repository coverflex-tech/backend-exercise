defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :data, :map
    field :user_id, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :data])
    |> validate_required([:user_id])
  end
end
