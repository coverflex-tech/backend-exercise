defmodule Benefits.Factory do
  @moduledoc """
  Factories to be used in tests
  """
  
  alias Benefits.{Repo, User}

  def build(:user) do
    %User{
      username: "John Doe"
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end