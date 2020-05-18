defmodule CoverFlexWeb.UserController do
use CoverFlexWeb, :controller
import Plug.Conn
alias CoverFlex.Accounts

  def show(conn, %{"id" => id}) do
    with user <- Accounts.ensure_user(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{user: user})
    end
  end

end
