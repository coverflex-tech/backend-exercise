defmodule BackendWeb.OrdersView do
  use BackendWeb, :view

  def render("create.json", %{order: %{id: id, items: items, total_amount: total_amount}}) do
    %{
      order: %{
        order_id: id,
        data: %{items: items, total: total_amount}
      }
    }
  end

  def render("error.json", %{order: %{error: reason}}), do: %{error: reason}
end
