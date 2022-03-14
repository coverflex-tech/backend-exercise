defmodule BenefitsAPI.ViewHelpers do
  @moduledoc false

  def render_money(%Money{} = money) do
    money
    |> Money.to_decimal()
    |> Decimal.to_float()
  end

  def render_money(money) when is_integer(money) do
    money
    |> Money.new()
    |> render_money()
  end
end
