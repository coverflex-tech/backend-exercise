defmodule Coverflex.Benefits.Money do

  def json_repr(value) do
    case rem(value, 100) do
      0 -> div(value, 100)
      _ -> value/100.0
    end
  end

end
