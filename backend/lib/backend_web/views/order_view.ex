defmodule BackendWeb.OrderView do
  use BackendWeb, :view

  def render("show.json", %{order: order}) do
    %{
      order: %{
        order_id: order.id,
        data: %{
          items: order.products,
          total: (order.total || 0 / 100) |> Float.round(2)
        }
      }
    }
  end
end
