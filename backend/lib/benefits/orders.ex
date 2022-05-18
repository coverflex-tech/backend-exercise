defmodule Benefits.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Benefits.Repo

  alias Benefits.Orders.{Order, OrderProduct}


  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, attrs))
    |> Multi.insert_all(:order_products, OrderProduct, fn %{order: order} ->
      Enum.map(order.items, fn item ->
        now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

        %{
          order_id: order.id,
          user_id: order.user_id,
          product_id: item,
          inserted_at: now,
          updated_at: now
        }
      end)
    end)
    |> Repo.transaction()
  rescue
    e in Postgrex.Error ->
      case e.postgres.constraint do
        "orders_products_user_id_product_id_index" ->
          {:error, :order, "products_already_purchased"}
      end
  end
end
