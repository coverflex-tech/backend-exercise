defmodule BenefitsWeb.OrderControllerTest do
  use BenefitsWeb.ConnCase, async: true
  import Benefits.Factory

  describe "create" do
    test "with valid fields", %{conn: conn} do
      products = insert_list(5, :product)
      products_identifier = products |> Enum.map(& &1.identifier)
      user = insert(:user, %{balance: 50})

      conn =
        post(
          conn,
          Routes.order_path(conn, :create, %{
            order: %{items: products_identifier, user_id: user.username}
          })
        )

      assert %{
               "order" => %{
                 "data" => %{
                   "items" => products,
                   "total" => 50.0
                 },
                 "order_id" => _
               }
             } = json_response(conn, 200)

      assert length(products) == 5
    end

    test "with insufficient balance", %{conn: conn} do
      products = insert_list(5, :product)
      products_identifier = products |> Enum.map(& &1.identifier)
      user = insert(:user)

      conn =
        post(
          conn,
          Routes.order_path(conn, :create, %{
            order: %{items: products_identifier, user_id: user.username}
          })
        )

      assert json_response(conn, 400) === %{"error" => "insufficient_balance"}
    end

    test "with non existing products", %{conn: conn} do
      user = insert(:user)

      conn =
        post(
          conn,
          Routes.order_path(conn, :create, %{
            order: %{items: ["non_existing_product"], user_id: user.username}
          })
        )

      assert json_response(conn, 400) === %{"error" => "products_not_found"}
    end

    test "with already purchased products", %{conn: conn} do
      products = insert_list(5, :product)
      user = insert(:user, %{balance: 1000, products: products})
      order = insert(:order, %{user: user, products: products})

      conn =
        post(
          conn,
          Routes.order_path(conn, :create, %{
            order: %{items: [List.first(order.products).identifier], user_id: user.username}
          })
        )

      assert json_response(conn, 400) === %{"error" => "products_already_purchased"}
    end
  end
end
