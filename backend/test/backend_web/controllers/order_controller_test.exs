defmodule BackendWeb.OrderControllerTest do
  use BackendWeb.ConnCase
  use Builders

  describe "create order" do
    test "should return a created order", %{conn: conn} do
      create_product(id: "p1", name: "P1", price: Decimal.new("10.00"))
      create_product(id: "p2", name: "P2", price: Decimal.new("10.00"))
      create_user(id: "bilbo")

      params = %{"order" => %{"user_id" => "bilbo", items: ["p1", "p2"]}}

      conn = post(conn, Routes.order_path(conn, :post), params)

      assert %{
               "order" => %{
                 "id" => _order_id,
                 "items" => ["p1", "p2"],
                 "total" => "20.00",
                 "user_id" => "bilbo"
               }
             } = json_response(conn, 200)
    end
  end
end
