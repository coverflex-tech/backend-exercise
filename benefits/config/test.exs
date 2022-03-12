import Config

config :logger, level: :warn

config :benefits, Benefits.Repo,
  database: "benefits_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :benefits, Benefits.Repo, pool: Ecto.Adapters.SQL.Sandbox
