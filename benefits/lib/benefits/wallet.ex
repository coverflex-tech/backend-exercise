defmodule Benefits.Wallet do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Benefits.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "wallets" do
    belongs_to(:user, User, type: Ecto.UUID)

    field(:amount, Money.Ecto.Amount.Type)

    timestamps()
  end

  @doc false
  def changeset(wallet \\ %__MODULE__{}, attrs) do
    wallet
    |> cast(attrs, [:user_id, :amount])
    |> validate_required([:user_id, :amount])
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
