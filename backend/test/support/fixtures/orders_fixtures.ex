defmodule Benefits.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Benefits.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{})
      |> Benefits.Orders.create_order()

    order
  end
end
