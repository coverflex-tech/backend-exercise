defmodule BackendWeb.UsersControllerTest do
  use BackendWeb.ConnCase, async: true

  alias Backend.Products.Product
  alias Backend.Repo
  alias Backend.Users.User

  describe "get/2" do
    test "when user exists, returns user", %{conn: conn} do
      user = %User{
        balance: 373.32,
        username: "johndoe"
      }

      %User{username: username} = Repo.insert!(user)

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

      Repo.insert!(product)
      Repo.insert!(product2)

      params = %{"order" => %{"user_id" => "johndoe", "items" => ["iphone", "dog"]}}

      Backend.Orders.Services.CreateOrder.call(params)

      response =
        conn
        |> get(Routes.users_path(conn, :get, username))
        |> json_response(200)

      assert %{
               "user" => %{
                 "data" => %{"balance" => 8.96, "product_ids" => ["iphone", "dog"]},
                 "user_id" => "johndoe"
               }
             } == response
    end

    test "when user doesnt exists, should create and return the user", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :get, "new_john_doe"))
        |> json_response(200)

      assert %{
               "user" => %{
                 "data" => %{"balance" => 0.0, "product_ids" => []},
                 "user_id" => "new_john_doe"
               }
             } == response
    end
  end
end
