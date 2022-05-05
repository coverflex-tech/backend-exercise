defmodule BackendWeb.OrdersView do
  use BackendWeb, :view

  def render("create.json", %{order: %{items: items, user_id: user_id}}) do
    %{
      order: %{
        items: items,
        user_id: user_id
      }
    }
  end

  def render("error.json", %{order: %{error: reason}}), do: %{error: reason}

  # {"order": {"items": ["product-1", "product-2"], "user_id": "johndoe"}}
end
