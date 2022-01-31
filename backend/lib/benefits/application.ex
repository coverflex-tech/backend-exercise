defmodule Benefits.Application do
  @moduledoc """
  This module implements the Application behaviour by defining the start/2 function.
  This way, this module can be used in the mix.exs, specifically in the application/0 function,
  so it can be invoked in the application startup.
  """

  use Application

  @doc """
  Called when an application is started.
  Starts the app's main supervisor with its children and arguments,
  as well as the supervision strategy, in this case a :one_for_one strategy.
  """
  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Benefits.Repo,
      # Start the Telemetry supervisor
      BenefitsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Benefits.PubSub},
      # Start the Endpoint (http/https)
      BenefitsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Benefits.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BenefitsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
