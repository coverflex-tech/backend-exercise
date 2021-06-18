defmodule CoverflexWeb.UserView do
  use CoverflexWeb, :view
  alias CoverflexWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{user: %{id: user.id, user_id: user.user_id}}
  end
end
