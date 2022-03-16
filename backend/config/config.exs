import Config

config :benefits,
  ecto_repos: [Benefits.Repo],
  generators: [binary_id: true]

config :benefits, BenefitsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BenefitsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Benefits.PubSub,
  live_view: [signing_salt: "Qk++WB6X"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
