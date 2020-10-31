defmodule CompanyBenefitsWeb.ErrorView do
  use CompanyBenefitsWeb, :view

  def render("400.json", _assigns) do
    %{errors: %{detail: "Bad request"}}
  end

  def render("404.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("business_rule.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.json", assigns)
  end
end
