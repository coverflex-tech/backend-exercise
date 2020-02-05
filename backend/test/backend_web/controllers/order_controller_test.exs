defmodule BackendWeb.OrderControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Accounts
  alias Backend.Benefits

  @product_attrs %{id: "netflix", name: "Netflix", price: 42}
  @user_attrs %{user_id: "user", data: %{balance: 50, product_ids: []}}

  @valid_attrs %{items: ["netflix"], user_id: "user"}
  @invalid_attrs %{items: ["spotify"], user_id: "user"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  def fixture(:product) do
    {:ok, product} = Benefits.create_product(@product_attrs)
    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create order" do
    setup [:create_product, :create_user]

    test "renders order when data is valid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @valid_attrs)

      assert %{
               "order_id" => id,
               "data" => %{"items" => ["netflix"], "total" => 42}
             } = json_response(conn, 200)["order"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_path(conn, :create), order: @invalid_attrs)
      assert json_response(conn, 400) == %{"error" => "products_not_found"}
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
