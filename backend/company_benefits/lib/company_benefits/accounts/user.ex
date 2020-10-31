defmodule CompanyBenefits.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:balance, :integer, default: 0)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :balance])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end