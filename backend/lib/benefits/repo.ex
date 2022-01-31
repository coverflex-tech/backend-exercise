defmodule Benefits.Repo do
  @moduledoc """
  Define a Repository. A repository maps to an underlying data store,
  controlled by the adapter. In this case, the Ecto.Adapters.Postgres
  adapter for a postgres database.
  """

  use Ecto.Repo,
    otp_app: :benefits,
    adapter: Ecto.Adapters.Postgres
end
