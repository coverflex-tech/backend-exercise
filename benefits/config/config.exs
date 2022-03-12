import Config

config :benefits,
  ecto_repos: [Benefits.Repo]

config :benefits, initial_wallet_amount: 50_000

config :money,
  default_currency: :EUR

import_config "#{Mix.env()}.exs"
