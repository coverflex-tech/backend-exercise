defmodule CoverflexWeb.UserControllerTest do
  use CoverflexWeb.ConnCase

  alias TestHelper.Fixtures
  alias Coverflex.Orders

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get user" do
    setup [:create_user]

    test "already created user", %{conn: conn, user: %{user_id: user_id, id: id}} do
      conn = get(conn, Routes.user_path(conn, :show, user_id))

      assert %{
               "user" => %{
                 "id" => ^id,
                 "user_id" => ^user_id,
                 "data" => %{
                   "balance" => 0,
                   "product_ids" => []
                 }
               }
             } = json_response(conn, 200)
    end

    test "creates a new user when do not exist", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, "adalovelace"))

      assert %{
               "user" => %{
                 "id" => _some_id,
                 "user_id" => "adalovelace",
                 "data" => %{
                   "balance" => 500,
                   "product_ids" => []
                 }
               }
             } = json_response(conn, 201)
    end

    test "get user with products", %{conn: conn} do
      product1 = Fixtures.product_fixture()
      balance = product1.price + 10

      %{id: id, user_id: user_id} = Fixtures.user_fixture(%{balance: balance}, with_account: true)

      products = [product1.id]
      {:ok, _} = Orders.buy_products(user_id, products)

      conn = get(conn, Routes.user_path(conn, :show, user_id))

      assert %{
               "user" => %{
                 "id" => ^id,
                 "user_id" => ^user_id,
                 "data" => %{
                   "balance" => 10,
                   "product_ids" => ^products
                 }
               }
             } = json_response(conn, 200)
    end
  end

  defp create_user(attrs) do
    user = Fixtures.user_fixture(attrs, with_account: true)
    %{user: user}
  end
end
