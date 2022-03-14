defmodule BenefitsAPI.UsersControllerTest do
  use BenefitsAPI.ConnCase

  describe "/api/users/:user_id" do
    setup do
      user = insert!(:user)
      wallet = insert!(:wallet, user_id: user.id, amount: 5000)
      order = insert!(:order, user_id: user.id)

      {:ok, user: user, wallet: wallet, order: order}
    end

    test "returns the user, its balance and the product ids already bought", ctx do
      path = Routes.users_path(@endpoint, :show, ctx.user.username)

      assert %{
               "user" => %{
                 "user_id" => ctx.user.username,
                 "data" => %{
                   "balance" => render_money(ctx.wallet.amount),
                   "product_ids" => Enum.map(ctx.order.products, & &1.id)
                 }
               }
             } ==
               ctx.conn
               |> get(path)
               |> json_response(200)
    end
  end
end
