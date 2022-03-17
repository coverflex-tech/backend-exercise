defmodule Benefits.Users.User do
  @moduledoc """
  Schema for an user
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @timestamps_opts [type: :naive_datetime_usec]

  @required [:username]
  @optional [:balance]

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key false
  schema "users" do
    field(:username, :string, primary_key: true, autogenerate: false)
    field(:balance, :integer, default: 20_000)

    timestamps()
  end

  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
