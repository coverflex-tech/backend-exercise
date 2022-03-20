defmodule Benefits.MixProject do
  use Mix.Project

  def project do
    [
      app: :benefits,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      preferred_cli_env: [
        "benefits.test_setup": :test,
        "benefits.test_reset": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Benefits.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:money, "~> 1.9"},
      {:phoenix, "~> 1.6.6"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      "benefits.reset": [
        "ecto.drop --quiet",
        "benefits.setup"
      ],
      "benefits.setup": [
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "run priv/repo/seeds.exs"
      ],
      "benefits.test_setup": [
        "benefits.setup"
      ],
      "benefits.test_reset": [
        "benefits.reset"
      ]
    ]
  end
end
