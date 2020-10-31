defmodule CompanyBenefitsWeb.UserControllerTest do
  use CompanyBenefitsWeb.ConnCase

  alias CompanyBenefits.Accounts
  alias CompanyBenefits.Accounts.User
  alias CompanyBenefits.Products.Product
  alias CompanyBenefits.Products.ProductContext
  alias CompanyBenefits.Orders

  @username "some username"

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

  describe "login" do
    test "should create user", %{conn: conn} do
      assert Accounts.UserContext.list_users() |> length() === 0
      get(conn, user_path(conn, :login, @username))
      assert Accounts.UserContext.list_users() |> length() === 1
    end

    test "should return an existing user", %{conn: conn} do
      %User{username: username} = fixture(:user)
      assert Accounts.UserContext.list_users() |> length() === 1

      response =
        get(conn, user_path(conn, :login, username))
        |> json_response(200)

      assert response["user"]["user_id"] == username

      assert Accounts.UserContext.list_users() |> length() === 1
    end

    test "should return an existing user with orders", %{conn: conn} do
      %User{username: username, balance: balance} = fixture(:user)
      %Product{price: price, identifier: identifier} = fixture(:product)

      assert balance == 400

      Orders.create_order(%{
        username: username,
        identifiers: [identifier]
      })

      response =
        get(conn, user_path(conn, :login, username))
        |> json_response(200)

      data = response["user"]["data"]

      assert data["balance"] == balance - price
      assert data["product_ids"] == [identifier]
    end
  end
end
