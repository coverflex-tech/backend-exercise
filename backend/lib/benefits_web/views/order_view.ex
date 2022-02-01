defmodule BenefitsWeb.OrderView do
  use BenefitsWeb, :view

  def render("show.json", %{order: order}), do: %{order: order}
end
