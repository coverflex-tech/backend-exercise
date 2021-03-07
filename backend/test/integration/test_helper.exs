if System.get_env("DIVO") do
  Divo.Suite.start()
end

ExUnit.start()

Repo.Migrator.migrate()
Ecto.Adapters.SQL.Sandbox.mode(Backend.Repo, :manual)
