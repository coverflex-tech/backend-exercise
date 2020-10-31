defmodule CompanyBenefitsWeb.OrderController do
  use CompanyBenefitsWeb, :controller

  alias CompanyBenefits.Orders
  alias CompanyBenefits.Orders.Order

  action_fallback(CompanyBenefitsWeb.FallbackController)

  def create(conn, %{"order" => %{"items" => identifiers, "user_id" => username}}) do
    with(
      false <- is_nil(username),
      true <- is_list(identifiers),
      {:ok, %Order{} = order} <-
        Orders.create_order(%{
          identifiers: identifiers,
          username: username
        })
    ) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    else
      error when is_boolean(error) ->
        :bad_request

      {:error, :user_not_found} ->
        {:not_found, "User not found"}

      {:error, :products_not_found} ->
        {:not_found, "Products not found"}

      {:error, :insufficient_balance} ->
        {:business_rule, "Insufficient balance"}

      {:error, :products_already_bought} ->
        {:business_rule, "Products already bought"}

      error ->
        error
    end
  end
end
