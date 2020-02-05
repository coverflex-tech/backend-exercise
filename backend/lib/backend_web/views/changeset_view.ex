defmodule BackendWeb.ChangesetView do
  use BackendWeb, :view

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1).title
    |> List.first()
  end

  def render("error.json", %{changeset: changeset}) do
    %{error: translate_errors(changeset)}
  end
end
