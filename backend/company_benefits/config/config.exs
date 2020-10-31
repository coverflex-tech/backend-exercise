# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :company_benefits,
  ecto_repos: [CompanyBenefits.Repo]

# Configures the endpoint
config :company_benefits, CompanyBenefitsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IJrDQa5OVrgN7FbK5LC2DB+89hB+NDm7M6ifRTYmJBjDm0Aq05zus9/mPEi0lMvd",
  render_errors: [view: CompanyBenefitsWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CompanyBenefits.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :company_benefits,
       CompanyBenefits.Accounts,
       default_balance: 400

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
