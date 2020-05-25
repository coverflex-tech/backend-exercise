defmodule CoverFlexWeb.UserController do
use CoverFlexWeb, :controller
import Plug.Conn
alias CoverFlex.Accounts
alias CoverFlex.Products

  def show(conn, %{"id" => id}) do
    with user <- Accounts.ensure_user(id) do
      products = Products.get_user_products(id)
      conn
      |> put_status(:ok)
      |> render("show.json", %{user: user, products: products})
    end
  end

end
