import Config

config :benefits, Benefits.Repo,
  database: "benefits_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :benefits, BenefitsAPI.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "hfuCWdXkfOb8tFpPqMwjlCP32ofdeiCi0CCAP0d/9Dlj9YIZi29+pSatSzvTw5sj",
  watchers: []
