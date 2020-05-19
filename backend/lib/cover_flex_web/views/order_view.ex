defmodule CoverFlexWeb.OrderView do
  use CoverFlexWeb, :view

  @doc """
  output 200 {"order": {"order_id": "123", "data": {"items": [...], "total": 500}}}
  output 400 {"error": "products_not_found"}
  output 400 {"error": "products_already_purchased"}
  output 400 {"error": "insufficient_balance"}
  """

  def render("show.json", %{order: order}) do
    %{order: render_one(order, __MODULE__, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{order_id: Integer.to_string(order.id),
      data: %{
        items: Enum.map(order.products, fn p -> p.id end),
        total: order.total
      }
    }
  end

  def render("products_not_found.json", _assigns) do
    %{error: "products_not_found"}
  end

  def render("poor.json", _assigns) do
    %{error: "insufficient_balance"}
  end

  def render("already_bought.json", _assigns) do
    %{error: "products_already_purchased"}
  end
end
