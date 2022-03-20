import Config

### Benefits application

config :benefits,
  ecto_repos: [Benefits.Repo]

config :benefits, initial_wallet_amount: 300_000

config :benefits, BenefitsAPI.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BenefitsAPI.ErrorView, accepts: ~w(json), layout: false]

### Other applications
config :money,
  default_currency: :EUR

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
