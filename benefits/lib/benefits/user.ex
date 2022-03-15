defmodule Benefits.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Benefits.Wallet

  schema "users" do
    field(:username, :string)

    has_one(:wallet, Wallet)

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
