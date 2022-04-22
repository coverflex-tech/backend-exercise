defmodule BackendWeb.OrderView do
  use BackendWeb, :view

  def render("show.json", %{order: order}) do
    %{
      order: %{
        order_id: order.id,
        data: %{
          items: order.benefits,
          total: order.total
        }
      }
    }
  end
end
