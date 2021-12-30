defmodule Coverflex.Benefits.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Coverflex.Benefits.Repo,
      # Start the Telemetry supervisor
      Coverflex.BenefitsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Coverflex.Benefits.PubSub},
      # Start the Endpoint (http/https)
      Coverflex.BenefitsWeb.Endpoint
      # Start a worker by calling: Coverflex.Benefits.Worker.start_link(arg)
      # {Coverflex.Benefits.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Coverflex.Benefits.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Coverflex.BenefitsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
