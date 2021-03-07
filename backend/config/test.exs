import Config

# Print nothing during tests but evaluate all log lines
config :logger,
  level: :debug,
  backends: []

config :backend, :modules,
  user_manager: Backend.Users.ManagerMock,
  user_manager: Backend.Products.ManagerMock

config :backend,
  ecto_repos: []

config :backend,
  divo: "test/support/docker-compose.yaml",
  divo_wait: [dwell: 700, max_tries: 50]
