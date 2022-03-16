import Config

config :benefits, Benefits.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "benefits_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :benefits, BenefitsWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "aJYfSM+/XskDZdJyUHNFu5wGf1NBjFaHZ2YQ11WqlWeASfAUM2lAdHm5m7fdec5W",
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
