import Config

config :backend,
  ecto_repos: [Backend.Repo]

config :backend, :user, default_balance: 1000

# Configures the endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vz7BF0Vw8T2Lo/YcFfRHKM7qCU96sNP3qzttKo7tadMaC7Y7tCtJyyAiawbPSN+r",
  render_errors: [view: BackendWeb.ErrorView, accepts: ~w(json), layout: false]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :backend, :modules,
  repo: Backend.Repo,
  user_manager: Backend.Users.Manager,
  product_manager: Backend.Products.Manager

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
