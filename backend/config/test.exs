import Config

config :benefits, Benefits.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "benefits_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :benefits, BenefitsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "68ENOrC92x5UZgWNnHncaxnQPHUcKub5IR15SNBGkvtCLp+W3PD1nXsit+17w9T7",
  server: false

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime
