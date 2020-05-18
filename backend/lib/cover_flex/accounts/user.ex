defmodule CoverFlex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, []}

  schema "users" do
    field :balance, :integer, default: 500

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end
end
