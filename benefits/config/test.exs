import Config

config :logger, level: :warn

config :benefits, Benefits.Repo,
  database: "benefits_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :benefits, Benefits.Repo, pool: Ecto.Adapters.SQL.Sandbox

config :benefits, PlaygroundWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kp+W2EdSY3UIqyQwb5dQknockm1Q8yQ4kEVc2YlwrOw6wGpvr8F+B9L5jGQT5sc4",
  server: false

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime
