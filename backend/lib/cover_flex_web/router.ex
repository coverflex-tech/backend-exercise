defmodule CoverFlexWeb.Router do
  use CoverFlexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoverFlexWeb do
    pipe_through :api

    get "/users/:id", UserController, :show

    get "/products", ProductController, :index

    post "/orders", OrderController, :create
  end
end
