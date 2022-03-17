defmodule Benefits.Application do
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Benefits.Repo,
      BenefitsWeb.Telemetry,
      BenefitsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Benefits.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    BenefitsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
