defmodule BackendWeb.OrdersControllerTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Products.Product
  alias Backend.Repo
  alias Backend.Users.User

  describe "create/2" do
    setup do
      user = %User{
        balance: 373.32,
        username: "johndoe"
      }

      user2 = %User{
        balance: 20,
        username: "doejohn"
      }

      Repo.insert!(user)
      Repo.insert!(user2)

      product = %Product{
        id: "iphone",
        name: "Iphone 3",
        price: 200.37
      }

      product2 = %Product{
        id: "dog",
        name: "Beethoven",
        price: 163.99
      }

      product3 = %Product{
        id: "youtube",
        name: "Youtube Premium",
        price: 20.99
      }

      Repo.insert!(product)
      Repo.insert!(product2)
      Repo.insert!(product3)

      {:ok, %{}}
    end

    test "when all params are valid, returns the order", %{conn: conn} do
      order = %{
        "order" => %{
          "items" => ["iphone", "dog"],
          "user_id" => "johndoe"
        }
      }

      response =
        conn
        |> post(Routes.orders_path(conn, :create, order))
        |> json_response(200)

      assert %{
               "order" => %{
                 "order_id" => _,
                 "data" => %{"items" => ["iphone", "dog"], "total" => "364.36"}
               }
             } = response
    end

    test "when some product are not valid, returns products_not_found error message", %{
      conn: conn
    } do
      order = %{
        "order" => %{
          "items" => ["nonexistent", "iphone"],
          "user_id" => "johndoe"
        }
      }

      response =
        conn
        |> post(Routes.orders_path(conn, :create, order))
        |> json_response(400)

      assert %{"error" => "products_not_found"} == response
    end

    test "when some product are already purchased, returns products_already_purchased error message",
         %{
           conn: conn
         } do
      order = %{
        "order" => %{
          "items" => ["iphone"],
          "user_id" => "johndoe"
        }
      }

      params = %{"order" => %{"user_id" => "johndoe", "items" => ["iphone", "dog"]}}

      Backend.Orders.Services.CreateOrder.call(params)

      response =
        conn
        |> post(Routes.orders_path(conn, :create, order))
        |> json_response(400)

      assert %{"error" => "products_already_purchased"} == response
    end

    test "when user doesnt has enough balance, returns insufficient_balance error message",
         %{
           conn: conn
         } do
      order = %{
        "order" => %{
          "items" => ["youtube"],
          "user_id" => "doejohn"
        }
      }

      response =
        conn
        |> post(Routes.orders_path(conn, :create, order))
        |> json_response(400)

      assert %{"error" => "insufficient_balance"} == response
    end
  end
end
