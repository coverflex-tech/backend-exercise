defmodule BackendWeb.ErrorView do
  use BackendWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("business_error.json", %{reason: reason}) do
    %{error: reason}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
