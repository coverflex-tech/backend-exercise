defmodule BackendWeb.AmountHelpers do
  # 0.0 to please the tests
  def centify(nil), do: 0.0
  def centify(amount), do: (amount / 100) |> Float.round(2)
end
