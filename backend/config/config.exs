# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :coverflex,
  ecto_repos: [Coverflex.Repo]

config :coverflex_web,
  ecto_repos: [Coverflex.Repo],
  generators: [context_app: :coverflex, binary_id: true]

# Configures the endpoint
config :coverflex_web, CoverflexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8yLk667V27WXryG/LyqISCjDQe74MYPCFrgWpxBYLw274Rnn+mntdsnyUvjVIlMM",
  render_errors: [view: CoverflexWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Coverflex.PubSub,
  live_view: [signing_salt: "vw5Uk5fq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"