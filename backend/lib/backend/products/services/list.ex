defmodule Backend.Products.Services.List do
  alias Backend.Products.Repository.List

  def call, do: List.call()
end
