defmodule Backend.Products.Changeset do
  import Ecto.Changeset

  alias Backend.Products.Product

  @fields [:name, :price, :order_id]

  @required_fields [:name, :price]

  def changeset(struct \\ %Product{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> validate_number(:price, greater_than: 0)
    |> foreign_key_constraint(:order_id)
  end
end
