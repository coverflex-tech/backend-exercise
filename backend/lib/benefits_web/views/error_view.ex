defmodule BenefitsWeb.ErrorView do
  use BenefitsWeb, :view

  def render("400.json", %{reason: reason}) do
    %{reason: reason}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
