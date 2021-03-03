defmodule Backend.Users.User do
  @moduledoc """
  User model
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:user_id, :string, autogenerate: false}

  schema "users" do
    field(:balance, :integer, default: 0)
    field(:product_ids, {:array, :string}, default: [])

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:user_id, :balance, :product_ids])
    |> validate_required([:user_id])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:user_id)
  end

  def order(user, items, total) do
    user
    |> changeset()
    |> dec_balance(total)
    |> add_products(items)
  end

  defp dec_balance(changeset, amount) do
    balance = get_field(changeset, :balance)

    if balance >= amount do
      put_change(changeset, :balance, balance - amount)
    else
      add_error(changeset, :balance, "insufficient_balance")
    end
  end

  defp add_products(changeset, items) do
    bought_items = get_field(changeset, :product_ids)
    product_ids = bought_items ++ items

    if Enum.uniq(product_ids) == product_ids do
      put_change(changeset, :product_ids, product_ids)
    else
      add_error(changeset, :product_ids, "products_already_purchased")
    end
  end
end
