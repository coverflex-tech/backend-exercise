import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("BACKEND_SECRET") ||
      raise "The BACKEND_SECRET environment variable must be defined"

  hostname =
    :inet.gethostname()
    |> elem(1)
    |> to_string()

  host = System.get_env("HOST", hostname)
  port = System.get_env("BACKEND_PORT", "4000") |> String.to_integer()

  config :backend, BackendWeb.Endpoint,
    url: [host: host],
    http: [
      port: port,
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    server: true

  database_url =
    System.get_env("BACKEND_DB_URL") ||
      raise "The BACKEND_DB_URL environment variable must be defined"

  config :backend, Backend.Repo, url: database_url
end
