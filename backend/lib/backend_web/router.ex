defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", BackendWeb do
    pipe_through(:api)

    resources("/users", UserController, except: [:new, :edit])
    resources("/products", ProductController, except: [:new, :edit])
    post("/orders", OrderController, :create)
  end
end
