import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
partition = System.get_env("MIX_TEST_PARTITION")

config :backend, Backend.Repo,
  url: "ecto://postgres:postgres@localhost/backend_test#{partition}",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :backend, BackendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print nothing during tests but evaluate all log lines
config :logger,
  level: :debug,
  backends: []

config :backend,
  divo: "test/support/docker-compose.yaml",
  divo_wait: [dwell: 700, max_tries: 50]
