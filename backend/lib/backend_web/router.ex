defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    get "/users/:username", UserController, :get_or_create_user
    get "/products", ProductController, :index
    post "/products", ProductController, :create
  end
end
