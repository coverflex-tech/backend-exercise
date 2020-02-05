defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{user: %{user_id: user.user_id, data: user.data}}
  end
end
