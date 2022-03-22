defmodule Backend.Orders do
  @moduledoc """
  Order Context to expose Order Api and common functions to Orders
  """
  alias Backend.Orders.Create

  defdelegate create_order(params), to: Create, as: :call
end
