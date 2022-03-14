defmodule Benefits.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Benefits.{Order, OrderProducts, Repo, Wallet}

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
