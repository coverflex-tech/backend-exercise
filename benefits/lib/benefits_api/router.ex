defmodule BenefitsAPI.Router do
  use BenefitsAPI, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", BenefitsAPI do
    pipe_through(:api)

    get("/users/:user_id", UsersController, :show)
    get("/products", ProductsController, :index)

    post("/orders", OrdersController, :create)
  end
end
