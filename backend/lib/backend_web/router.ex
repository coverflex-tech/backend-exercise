defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", BackendWeb do
    pipe_through(:api)

    # Retrieves a user by id:
    # This is in fact an ati-pattern but it's what the cx asked for
    # It should be modeled as a GET only
    # Client can make a PUT request to add a new resource
    get("/users/:user_id", UsersController, :get)

    # Retrieves the list of all products
    # Moving forward we probably want this paginated and/or filterable
    # so it scales
    get("/products", ProductsController, :list)

    # Creates a new order
    # Again an anti-pattern, should be a PUT request instead
    post("/orders", UsersController, :order)
  end
end
