defmodule Backend.Orders.Changeset do
  import Ecto.Changeset

  alias Backend.Orders.Order

  @fields [:user_id, :total_amount]

  @required_fields [:user_id, :total_amount]

  def changeset(struct \\ %Order{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_number(:total_amount, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:user_id)
  end
end
