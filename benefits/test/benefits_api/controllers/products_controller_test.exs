defmodule BenefitsAPI.ProductsControllerTest do
  use BenefitsAPI.ConnCase

  describe "/api/products" do
    setup do
      products = for _ <- 1..10, do: insert!(:product)
      {:ok, products: products}
    end

    test "returns all products", ctx do
      path = Routes.products_path(@endpoint, :index)

      assert %{
               "products" =>
                 Enum.map(ctx.products, fn p ->
                   %{"id" => p.id, "name" => p.name, "price" => render_money(p.price)}
                 end)
             } ==
               ctx.conn
               |> get(path)
               |> json_response(200)
    end
  end
end
