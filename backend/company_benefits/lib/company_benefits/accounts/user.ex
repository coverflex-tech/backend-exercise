defmodule CompanyBenefits.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:balance, :integer, default: 0)
    field(:username, :string)

    has_many(:orders, CompanyBenefits.Orders.Order, on_delete: :delete_all)

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
