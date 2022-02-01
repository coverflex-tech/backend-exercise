defmodule BackendWeb.BadRequestView do
  use BackendWeb, :view

  @doc """
  Render validation errors.
  """
  def render("bad_request.json", %{message: message}) do
    %{error: message}
  end
end
