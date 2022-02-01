defmodule BenefitsWeb.OrderController do
  @moduledoc """
  Contains the controller functions that respond to specific endpoints related to order resources.
  """

  use BenefitsWeb, :controller

  alias Benefits.Perks

  action_fallback BenefitsWeb.FallbackController

  @spec create(Plug.Conn.t(), map) :: {:error, binary} | Plug.Conn.t()
  def create(conn, %{"order" => %{"items" => identifiers, "user_id" => user_id}}) do
    with {:ok, order} <- Perks.create_order(identifiers, user_id) do
      conn
      |> put_status(:created)
      |> render("show.json", order: order)
    end
  end
end
