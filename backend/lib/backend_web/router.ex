defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BackendWeb do
    pipe_through :api

    resources "/users", UserController, only: [:show], param: "user_id"
    resources "/products", ProductController, only: [:index]
    resources "/orders", OrderController, only: [:create]
  end
end
