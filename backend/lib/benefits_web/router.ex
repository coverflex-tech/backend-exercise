defmodule BenefitsWeb.Router do
  use BenefitsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BenefitsWeb do
    pipe_through :api

    get("/users/:user_id", UsersController, :get)
  end
end
