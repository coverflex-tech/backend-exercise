defmodule CoverFlex.OrderControllerTest do
  use CoverFlexWeb.ConnCase
  alias CoverFlex.Repo
  alias CoverFlex.Products.Product
  alias CoverFlexWeb.Router.Helpers, as: Routes

  @valid_attrs %{"order" => %{"items" => ["netflix", "andchill"], "user_id" => "johndoe"}}
  @invalid_product_attrs %{"order" => %{"items" => ["invalid", "products"], "user_id" => "johndoe"}}
  @expensive_product_attrs %{"order" => %{"items" => ["nsabook", "bing"], "user_id" => "johndoe"}}

  setup do
    Repo.insert(%Product{id: "netflix", name: "Netflix", price: 75})
    Repo.insert(%Product{id: "andchill", name: "&Chill", price: 100})
    Repo.insert(%Product{id: "nsabook", name: "NSAbook", price: 250})
    Repo.insert(%Product{id: "bing", name: "Bing", price: 300})
    Repo.insert(%Product{id: "gamespy", name: "Game Spy", price: 10})
    :ok
  end

  describe "create" do
    test "create an order with all valid attrs", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create, @valid_attrs))
      assert response = json_response(conn, 200)["order"]

      # PK sequence presists between tests, so don't hardcode the order_id value
      assert response == %{
        "order_id" => response["order_id"],
        "data" => %{"items" => ["netflix", "andchill"], "total" => 175}
      }
    end

    test "create an order with invalid products", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create, @invalid_product_attrs))
      assert json_response(conn, 400) == %{"error" => "products_not_found"}
    end

    test "create an order with total superior to user balance", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create, @expensive_product_attrs))
      assert json_response(conn, 400) == %{"error" => "insufficient_balance"}
    end

    test "create an order and try to order the same things again", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create, @valid_attrs))
      assert response = json_response(conn, 200)["order"]

      # PK sequence presists between tests, so don't hardcode the order_id value
      assert response == %{
        "order_id" => response["order_id"],
        "data" => %{"items" => ["netflix", "andchill"], "total" => 175}
      }

      conn = post(conn, Routes.order_path(conn, :create, @valid_attrs))
      assert json_response(conn, 400) == %{"error" => "products_already_purchased"}
    end
  end
end
