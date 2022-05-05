defmodule Backend.Users.Changeset do
  import Ecto.Changeset

  alias Backend.Users.User

  @fields [:username, :balance]

  @required_fields []

  def changeset(struct \\ %User{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:username])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
