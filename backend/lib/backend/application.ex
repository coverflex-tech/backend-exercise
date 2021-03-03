defmodule Backend.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      Backend.Repo,
      BackendWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Backend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
