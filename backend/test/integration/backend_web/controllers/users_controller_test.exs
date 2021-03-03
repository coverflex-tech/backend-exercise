defmodule BackendWeb.UsersControllerTest do
  use BackendWeb.ConnCase, async: true
  alias Backend.Products.Product
  alias Backend.Repo
  alias Backend.Users.{Order, User}

  @default_user_balance Application.compile_env!(:backend, [
                          :user,
                          :default_balance
                        ])

  describe "get" do
    test "returns an existing user", %{conn: conn} do
      # Arrange
      user_id = "id"
      create_user(user_id, 12, ["id1", "id2"])

      expected = %{
        "user" => %{
          "user_id" => user_id,
          "data" => %{"balance" => 12, "product_ids" => ["id1", "id2"]}
        }
      }

      # Act
      actual =
        conn
        |> get("/api/users/#{user_id}")
        |> json_response(200)

      # Assert
      assert ^expected = actual
    end

    test "returns a new user", %{conn: conn} do
      # Arrange
      user_id = "id"

      expected = %{
        "user" => %{
          "user_id" => user_id,
          "data" => %{"balance" => @default_user_balance, "product_ids" => []}
        }
      }

      # Act
      actual =
        conn
        |> get("/api/users/#{user_id}")
        |> json_response(201)

      # Assert
      assert ^expected = actual
    end
  end

  describe "order" do
    test "returns 200 %Order on success", %{conn: conn} do
      # Arrange
      user_id = "user_id"
      product_ids = ["product_id_1", "product_id_2"]

      create_user(user_id)
      create_products(2)

      # Act
      actual =
        conn
        |> post("/api/orders", %{"order" => %{"items" => product_ids, "user_id" => user_id}})
        |> json_response(200)

      # Assert
      assert %{
               "order" => %{
                 "data" => %{
                   "items" => ^product_ids,
                   "total" => 3
                 },
                 "order_id" => _
               }
             } = actual
    end

    test "updates user on success", %{conn: conn} do
      # Arrange
      user_id = "user_id"
      product_ids = ["product_id_1", "product_id_2"]

      expected_balance = 97
      create_user(user_id)
      create_products(2)

      # Act
      %{"order" => _} =
        conn
        |> post("/api/orders", %{"order" => %{"items" => product_ids, "user_id" => user_id}})
        |> json_response(200)

      # Assert
      assert %User{balance: ^expected_balance, product_ids: ^product_ids} =
               Repo.get(User, user_id)
    end

    test "inserts an order", %{conn: conn} do
      # Arrange
      user_id = "user_id"
      product_ids = ["product_id_10", "product_id_9"]

      expected_total = 19
      create_user(user_id)
      create_products(10)

      # Act
      %{
        "order" => %{
          "order_id" => order_id
        }
      } =
        conn
        |> post("/api/orders", %{"order" => %{"items" => product_ids, "user_id" => user_id}})
        |> json_response(200)

      # Assert
      assert %Order{user_id: ^user_id, items: ^product_ids, total: ^expected_total} =
               Repo.get(Order, order_id)
    end

    test "returns 400 'products_not_found' on failure", %{conn: conn} do
      # Arrange
      user_id = "user_id"
      product_ids = ["p1", "p2"]

      create_user(user_id)
      create_products(10)

      # Act
      actual =
        conn
        |> post("/api/orders", %{"order" => %{"items" => product_ids, "user_id" => user_id}})
        |> json_response(400)

      # Assert
      assert %{"error" => "products_not_found"} == actual
    end

    test "returns 400 'products_already_purchased' on failure", %{conn: conn} do
      # Arrange
      user_id = "user_id"
      product_ids = ["product_id_1", "product_id_3"]

      create_user(user_id, 100, ["product_id_1", "product_id_2"])
      create_products(3)

      # Act
      actual =
        conn
        |> post("/api/orders", %{"order" => %{"items" => product_ids, "user_id" => user_id}})
        |> json_response(400)

      # Assert
      assert %{"error" => "products_already_purchased"} == actual
    end

    test "returns 400 'insufficient_balance' on failure", %{conn: conn} do
      # Arrange
      user_id = "user_id"
      product_ids = ["product_id_1"]

      create_user(user_id, 0)
      create_products(1)

      # Act
      actual =
        conn
        |> post("/api/orders", %{"order" => %{"items" => product_ids, "user_id" => user_id}})
        |> json_response(400)

      # Assert
      assert %{"error" => "insufficient_balance"} == actual
    end
  end

  defp create_products(
         count,
         id_naming_fun \\ &"product_id_#{&1}",
         name_naming_fun \\ &"name_#{&1}",
         pricing_fun \\ & &1
       ) do
    for idx <- 1..count do
      Repo.insert!(%Product{
        id: id_naming_fun.(idx),
        name: name_naming_fun.(idx),
        price: pricing_fun.(idx)
      })
    end
  end

  defp create_user(id, balance \\ 100, product_ids \\ []) do
    Repo.insert!(%User{user_id: id, balance: balance, product_ids: product_ids})
  end
end
