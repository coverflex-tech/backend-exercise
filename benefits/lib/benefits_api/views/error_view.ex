defmodule BenefitsAPI.ErrorView do
  use BenefitsAPI, :view

  def render("client_error.json", %{reason: reason}) do
    %{error: reason}
  end
end
