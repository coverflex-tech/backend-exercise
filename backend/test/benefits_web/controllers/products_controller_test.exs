defmodule BenefitsWeb.ProductsControllerTest do
  use BenefitsWeb.ConnCase, async: true

  import Benefits.Factory

  describe "index/2" do
    test "returns 200 and all products", ctx do
      product1 = insert(:product)
      product2 = insert(:product)

      assert %{
               "products" => [
                 %{
                   "id" => product1.id,
                   "name" => product1.name,
                   "price" => product1.price
                 },
                 %{
                   "id" => product2.id,
                   "name" => product2.name,
                   "price" => product2.price
                 }
               ]
             } ==
               ctx.conn
               |> get("/api/products")
               |> json_response(200)
    end

    test "returns 200 and no products", ctx do
      assert %{
               "products" => []
             } ==
               ctx.conn
               |> get("/api/products")
               |> json_response(200)
    end
  end
end
