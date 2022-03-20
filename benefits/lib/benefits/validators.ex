defmodule Benefits.Validators do
  @moduledoc """
  Helpers for validating inputs

  The functions contained by this module are often used for
  validating data that will be used by a domain function
  """

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
