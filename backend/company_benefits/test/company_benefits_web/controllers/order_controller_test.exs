defmodule CompanyBenefitsWeb.OrderControllerTest do
  use CompanyBenefitsWeb.ConnCase

  alias CompanyBenefits.Accounts
  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Accounts.{User, UserContext}

  @username "some username"
  @invalid_attrs %{user_id: "other user", items: []}
  @invalid_user_attrs %{user_id: nil, items: []}

  def fixture(:user) do
    {:ok, user} = Accounts.login(@username)
    user
  end

  def fixture(:product) do
    {:ok, product} =
      ProductContext.create_product(%{
        identifier: "product",
        name: "product",
        price: 10
      })

    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    setup [:create_user, :create_product]

    test "renders order when data is valid", %{
      conn: conn,
      user: %User{username: username},
      product: product
    } do
      conn =
        post(conn, order_path(conn, :create),
          order: %{user_id: username, items: [product.identifier]}
        )

      assert %{"data" => data} = json_response(conn, 201)["order"]

      assert data["total"] == product.price
    end

    test "renders errors when user does not have funds", %{
      conn: conn,
      user: %User{username: username} = user,
      product: product
    } do
      UserContext.update_user(user, %{balance: 0})

      conn =
        post(conn, order_path(conn, :create),
          order: %{user_id: username, items: [product.identifier]}
        )

      assert json_response(conn, 400)["errors"] != %{}
    end

    test "renders errors when items are invalid", %{conn: conn, user: %User{username: username}} do
      conn =
        post(conn, order_path(conn, :create),
          order: %{user_id: username, items: ["other product"]}
        )

      assert json_response(conn, 404)
    end

    test "renders errors when items are empty", %{conn: conn, user: %User{username: username}} do
      conn = post(conn, order_path(conn, :create), order: %{user_id: username, items: []})
      assert json_response(conn, 422)
    end

    test "renders errors when user does not exist", %{conn: conn} do
      conn = post(conn, order_path(conn, :create), order: @invalid_attrs)
      assert json_response(conn, 404)
    end

    test "renders errors when user is invalid", %{conn: conn} do
      conn = post(conn, order_path(conn, :create), order: @invalid_user_attrs)
      assert json_response(conn, 400)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
