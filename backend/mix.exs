defmodule Backend.MixProject do
  use Mix.Project

  def project do
    [
      app: :backend,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_paths: test_paths(Mix.env())
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Backend.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/unit/support"]
  defp elixirc_paths(:integration), do: ["lib", "test/support", "test/integration/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ecto_sql, "~> 3.4"},
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:divo, "~> 1.3.0", only: [:test, :integration]},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: [:test]},
      {:phoenix, "~> 1.5.7"},
      {:phoenix_ecto, "~> 4.1"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:sobelow, "~> 0.10", only: :test}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "compile"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      verify: ["setup", "test.all", "format", "credo --strict", "vulns"],
      "test.all": ["format --check-formatted", "test.unit", "test.integration"],
      "test.unit": &run_unit_tests/1,
      "test.integration": &run_integration_tests/1,
      vulns: &run_vulnerability_tests/1,
      profile: [
        "run bench/backend/products/manager_profile.exs",
        "run bench/backend/users/manager_profile.exs"
      ]
    ]
  end

  defp test_paths(:integration), do: ["test/integration"]
  defp test_paths(:feature), do: ["test/features"]
  defp test_paths(:test), do: ["test/unit"]
  defp test_paths(_), do: []

  def run_unit_tests(args), do: test_with_env("test", args)
  def run_integration_tests(args), do: test_with_env("integration", args)
  def run_feature_tests(args), do: test_with_env("feature", args)
  def run_vulnerability_tests(args), do: run_with_env("test", ["sobelow", "--config" | args])

  def test_with_env(env, args), do: run_with_env(env, ["test" | args])

  def run_with_env(env, [action | args]) do
    args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]
    IO.puts("==> Running #{action} with `MIX_ENV=#{env}`")

    {_, res} =
      System.cmd("mix", [action | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", to_string(env)}],
        stderr_to_stdout: true
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
