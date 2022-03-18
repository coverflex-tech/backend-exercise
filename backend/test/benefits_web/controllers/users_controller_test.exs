defmodule BenefitsWeb.UsersControllerTest do
  use BenefitsWeb.ConnCase, async: true

  import Benefits.Factory

  alias Benefits.Repo
  alias Benefits.Users.User

  @default_balance 20_000

  describe "show/2" do
    setup do
      products = build_list(3, :product)
      user = insert(:user)
      insert(:order, user_id: user.username, products: products)

      %{products: products, user: user}
    end

    test "returns 200 with user and purchase information", ctx do
      assert response =
               ctx.conn
               |> get("/api/users/#{ctx.user.username}")
               |> json_response(200)

      product_ids = Enum.map(ctx.products, & &1.id)

      assert response == %{
               "user" => %{
                 "user_id" => ctx.user.username,
                 "data" => %{
                   "balance" => ctx.user.balance,
                   "product_ids" => product_ids
                 }
               }
             }
    end

    test "returns 200 and creates an user", ctx do
      assert response =
               ctx.conn
               |> get("/api/users/redrum")
               |> json_response(200)

      assert response == %{
               "user" => %{
                 "user_id" => "redrum",
                 "data" => %{
                   "balance" => @default_balance,
                   "product_ids" => []
                 }
               }
             }

      assert Repo.get_by(User, username: "redrum")
    end
  end
end
