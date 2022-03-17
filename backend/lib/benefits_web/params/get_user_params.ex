defmodule BenefitsWeb.Params.GetUserParams do
  @moduledoc """
  Input params for fetching users
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @primary_key false
  embedded_schema do
    field(:user_id, :string)
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, [:user_id])
    |> validate_required(:user_id)
    |> maybe_apply_changes()
  end

  defp maybe_apply_changes(%{valid?: false} = _changeset), do: {:error, :invalid_params}
  defp maybe_apply_changes(changeset), do: {:ok, apply_changes(changeset)}
end
