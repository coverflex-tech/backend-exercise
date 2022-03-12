import Config

config :benefits,
  ecto_repos: [Benefits.Repo]

config :benefits, Benefits.Repo,
  database: "benefits_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
