import Config

config :benefits,
  ecto_repos: [Benefits.Repo]

import_config "#{Mix.env()}.exs"
