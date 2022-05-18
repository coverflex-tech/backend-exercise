defmodule BenefitsWeb.UserController do
  use BenefitsWeb, :controller

  alias Benefits.Users
  action_fallback BenefitsWeb.FallbackController

  def show(conn, %{"user_id" => user_id}) do
    user = Users.find_or_create_user(user_id)
    render(conn, "show.json", user: user)
  end
end
