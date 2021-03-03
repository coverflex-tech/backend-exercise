defmodule Repo.Migrator do
  @app :backend

  def migrate do
    for repo <- repos() do
      repo
      |> ensure_repo_created
      |> migrate
    end
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp migrate(repo) do
    case Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true)) do
      {:ok, _, _} -> repo
      {:error, reason} -> raise "Migration error: #{inspect(reason)}"
    end
  end

  defp ensure_repo_created(repo) do
    case repo.__adapter__.storage_up(repo.config) do
      :ok -> repo
      {:error, :already_up} -> repo
      {:error, reason} -> raise "Create db error: #{inspect(reason)}"
    end
  end
end
