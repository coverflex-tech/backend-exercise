defmodule BackendWeb.ProductsView do
  use BackendWeb, :view

  def render("products.json", %{products: products}) do
    %{products: handle_products(products)}
  end

  defp handle_products(products) do
    Enum.map(products, fn %{id: id, name: name, price: price} ->
      %{id: id, name: name, price: price}
    end)
  end
end
