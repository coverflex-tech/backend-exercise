defmodule CompanyBenefitsWeb.UserController do
  use CompanyBenefitsWeb, :controller

  alias CompanyBenefits.Accounts
  alias CompanyBenefits.Accounts.User

  action_fallback(CompanyBenefitsWeb.FallbackController)

  def login(conn, %{"username" => username}) do
    with {:ok, %User{} = user} <- Accounts.login(username) do
      conn
      |> render("user.json", user: user)
    end
  end
end
