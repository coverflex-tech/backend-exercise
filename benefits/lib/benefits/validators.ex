defmodule Benefits.Validators do
  @moduledoc false

  import Ecto.Changeset

  @doc "Validate and apply the given changeset and params into a struct"
  @spec validate(params :: map(), input :: module()) ::
          {:ok, struct()} | {:error, Ecto.Changeset.t()}
  def validate(params, input) do
    params
    |> input.changeset()
    |> case do
      %{valid?: true} = changeset -> {:ok, apply_changes(changeset)}
      invalid_changeset -> {:error, invalid_changeset}
    end
  end
end
