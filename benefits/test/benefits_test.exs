defmodule BenefitsTest do
  use ExUnit.Case
  doctest Benefits

  test "greets the world" do
    assert Benefits.hello() == :world
  end
end
