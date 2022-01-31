defmodule Benefits.MixProject do
  @moduledoc """
  Module that configures the current Mix project.
  The module exports a project/0 function that returns a keyword list representing the project's configuration and
  defines an application/0 function for configuring the generated application that also returns a keyword list which
  represents the app's configuration.
  """

  use Mix.Project

  @doc """
  This function is exported by the Mix.Project behaviour and configures this project by returning a keyword list
  containing the project's configuration.
  """
  @spec project() :: keyword(any())
  def project do
    [
      app: :benefits,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  @doc """
  Configures the OTP application.
  Configures the generated application (.app file) by defining a keyword list of configurations.
  Run "mix help compile.app" to learn about applications.
  """
  @spec application() :: keyword(any())
  def application do
    [
      mod: {Benefits.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  @spec elixirc_paths(:dev | :prod | :test) :: list(String.t())
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # This function defines the dependencies of the project.
  # Run "mix help deps" to learn about dependencies.
  @spec deps() :: list(tuple())
  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  # This function defines aliases for the project.
  # Aliases are shortcuts or tasks specific to the current project.
  @spec aliases() :: keyword(list(String.t()))
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
