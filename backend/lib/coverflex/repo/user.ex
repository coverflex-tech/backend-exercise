defmodule Coverflex.Benefits.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :name])
    |> validate_required([:user_id, :name])
    |> unique_constraint(:user_id)
  end
end
