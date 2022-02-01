defmodule BenefitsWeb.OrderController do
  use BenefitsWeb, :controller

  alias Benefits.Perks

  action_fallback BenefitsWeb.FallbackController

  def create(conn, %{"order" => %{"items" => identifiers, "user_id" => user_id}}) do
    with {:ok, order} <- Perks.create_order(identifiers, user_id) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end
end
