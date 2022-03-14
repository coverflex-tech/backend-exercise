defmodule BenefitsAPI.UsersController do
  @moduledoc false

  use BenefitsAPI, :controller

  alias BenefitsAPI.UsersView

  def show(conn, %{"user_id" => username}) do
    {:ok, user} = Benefits.get_or_create_user(username)
    {:ok, product_ids} = Benefits.list_bought_products_ids(user.id)

    conn
    |> put_status(:ok)
    |> put_view(UsersView)
    |> render("user.json", %{user: user, bought_products_ids: product_ids})
  end
end
