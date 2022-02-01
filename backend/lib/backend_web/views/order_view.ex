defmodule BackendWeb.OrderView do
  use BackendWeb, :view
  alias BackendWeb.OrderView

  def render("show.json", %{order: order, items: items}) do
    %{
      order: %{
        order_id: "#{order.id}",
        data: %{
          items: items |> Enum.map(fn i -> i.product_id end),
          total: order.total / 100
        }
      }
    }
  end
end
