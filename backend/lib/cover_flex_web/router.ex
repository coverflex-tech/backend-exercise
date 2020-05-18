defmodule CoverFlexWeb.Router do
  use CoverFlexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoverFlexWeb do
    pipe_through :api

    get "/users/:id", UserController, :show
  end
end
