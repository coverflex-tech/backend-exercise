defmodule BenefitsWeb.Router do
  use BenefitsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BenefitsWeb do
    pipe_through :api
  end
end
