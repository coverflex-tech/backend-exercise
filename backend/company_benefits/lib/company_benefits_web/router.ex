defmodule CompanyBenefitsWeb.Router do
  use CompanyBenefitsWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/users", CompanyBenefitsWeb do
    pipe_through(:api)

    get("/:username", UserController, :login)
  end

  scope "/products", CompanyBenefitsWeb do
    pipe_through(:api)

    get("/", ProductController, :index)
  end
end
