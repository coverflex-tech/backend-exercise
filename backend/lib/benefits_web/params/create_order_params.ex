defmodule BenefitsWeb.Params.CreateOrderParams do
  @moduledoc """
  Input params for creating orders
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  @required_fields [:items, :user_id]

  @primary_key false
  embedded_schema do
    field(:items, {:array, Ecto.UUID})
    field(:user_id, :string)
  end

  def changeset(data \\ %__MODULE__{}, params) do
    data
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> maybe_apply_changes()
  end

  defp maybe_apply_changes(%{valid?: false} = _changeset), do: {:error, :invalid_params}
  defp maybe_apply_changes(changeset), do: {:ok, apply_changes(changeset)}
end
