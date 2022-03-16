defmodule Benefits.Repo do
  use Ecto.Repo,
    otp_app: :benefits,
    adapter: Ecto.Adapters.Postgres
end
