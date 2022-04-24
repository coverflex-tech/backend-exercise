defmodule BackendWeb.OrderView do
  use BackendWeb, :view
  alias BackendWeb.AmountHelpers

  def render("show.json", %{order: order}) do
    %{
      order: %{
        order_id: order.id,
        data: %{
          items: order.products,
          total: AmountHelpers.centify(order.total)
        }
      }
    }
  end
end
