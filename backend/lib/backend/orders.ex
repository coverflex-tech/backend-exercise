defmodule Backend.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Orders.{Order}

  @doc """
  Returns the list of user orders.

  ## Examples

      iex> list_orders("test")
      [%Order{}, ...]

  """
  def list_orders(user_id) do
    from(o in Order, where: [user_id: ^user_id], order_by: [asc: :id])
    |> Repo.all()
  end

  def create_order(nil, _), do: {:error, "user_not_found"}
  def create_order(_user, []), do: {:error, "products_not_found"}

  def create_order(_user, _products) do
    {:ok, "order created"}
  end
end
