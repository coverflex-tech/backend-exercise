defmodule BackendWeb.APITest do
  use BackendWeb.ConnCase

  import Backend.BenefitsFixtures

  alias Backend.Repo
  alias Backend.Benefits.{Order, User}
  alias BackendWeb.AmountHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "API spec" do
    test "all routes", %{conn: conn} do
      # The DB is empty, so let's create a user
      assert Backend.Repo.all(Backend.Benefits.User) == []

      user = user_fixture(%{user_id: "test_user", balance: 50})
      conn = get(conn, "/api/users/test_user")

      # The user does get created...
      assert ^user = Repo.get(User, "test_user")

      # ... and returned as the API expects it
      expected_user = %{
        "user" => %{
          "user_id" => user.user_id,
          "data" => %{
            "balance" => AmountHelpers.centify(user.balance),
            "product_ids" => []
          }
        }
      }

      assert ^expected_user = json_response(conn, 200)

      # We want our test user to be able to place an order, so let's create some products
      products = [
        %{id: "cheap", name: "Some cheap product", price: 1},
        %{id: "normal", name: "Some normal product", price: 15},
        %{id: "expensive", name: "Ridiculous!!", price: 1000}
      ]

      Enum.each(products, &product_fixture/1)

      # We can get a list of all products
      conn = get(conn, "/api/products")

      expected_products = %{
        "products" =>
          Enum.map(
            products,
            &%{"id" => &1[:id], "name" => &1[:name], "price" => AmountHelpers.centify(&1[:price])}
          )
      }

      assert ^expected_products = json_response(conn, 200)

      # Then we can choose products we want
      items = ["cheap", "normal"]
      order_data = %{"order" => %{"user_id" => "test_user", "items" => items}}
      conn = post(conn, "/api/orders", order_data)

      # The order is returned as expected
      assert %{
               "order" => %{
                 "order_id" => order_id,
                 "data" => %{
                   "items" => ^items,
                   # The total comes as the normal price in euros, not the DB version in cents
                   "total" => 0.16
                 }
               }
             } = json_response(conn, 201)

      # We can also see that the order has the correct user and total...
      order = Repo.get!(Order, order_id)
      assert order.user_id == "test_user"
      assert order.total == 16

      # ...as well as the corresponding products
      order = Repo.preload(order, :benefits)

      order_benefits =
        order.benefits
        |> Enum.map(fn benefit -> benefit.product_id end)
        |> Enum.sort()

      assert order_benefits == Enum.sort(items)

      # This also affects the user resource
      conn = get(conn, "/api/users/test_user")

      expected_user = %{
        "user" => %{
          "user_id" => user.user_id,
          "data" => %{
            # Represented with cents in the API
            "balance" => 0.34,
            "product_ids" => ["cheap", "normal"]
          }
        }
      }

      assert ^expected_user = json_response(conn, 200)

      # This, however, does not create a new user in the DB
      assert Backend.Repo.all(Backend.Benefits.User) |> length == 1

      # We refuse an order in a few scenarios. One of them is if the user already has
      # one of the products
      new_order_data = %{"order" => %{"user_id" => "test_user", "items" => ["normal"]}}
      conn = post(conn, "/api/orders", new_order_data)

      # What we get is not this...
      refute %{
               "order" => %{
                 "order_id" => order_id + 1,
                 "data" => %{
                   "items" => ["normal"],
                   # The total comes as the normal price in euros, not the DB version in cents
                   "total" => 0.15
                 }
               }
             } == json_response(conn, 422)

      # ...but this instead
      assert %{
               "errors" => %{
                 "user" => ["The user already owns a product in this order."]
               }
             } = json_response(conn, 422)

      # The user cannot buy that which they cannot afford, either
      expensive_order_data = %{"order" => %{"user_id" => "test_user", "items" => ["expensive"]}}
      conn = post(conn, "/api/orders", expensive_order_data)

      assert %{"errors" => %{"user" => ["Insufficient balance"]}} = json_response(conn, 422)

      # Neither is it possible to buy a non-existent product
      invalid_order_data = %{"order" => %{"user_id" => "test_user", "items" => ["invalid"]}}
      conn = post(conn, "/api/orders", invalid_order_data)

      assert %{"errors" => %{"product" => ["There is no such product."]}} =
               json_response(conn, 422)

      # Finally, an order for a non-existent user also fails
      invalid_user_order_data = %{"order" => %{"user_id" => "0", "items" => ["cheap", "normal"]}}
      conn = post(conn, "/api/orders", invalid_user_order_data)

      assert %{"errors" => %{"user_id" => ["does not exist"]}} = json_response(conn, 422)
    end
  end
end
