import Config

config :benefits, Benefits.Repo,
  database: "benefits_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
