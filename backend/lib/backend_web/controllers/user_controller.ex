defmodule BenefitsWeb.UserController do
  use BenefitsWeb, :controller

  alias Benefits.Users

  action_fallback BenefitsWeb.FallbackController

  def show(conn, %{"id" => username}) do
    case Users.get_by_username(username) do
      {:ok, user} -> render(conn, "user.json", user: user)
      error -> error
    end
  end
end
