defmodule BenefitsWeb.OrderController do
  use BenefitsWeb, :controller

  alias Benefits.Orders

  action_fallback BenefitsWeb.FallbackController

  def create(conn, %{"order" => order_params}) do
    with {:ok, %{order: order}} <- Orders.create_order(order_params) do
      conn
      |> put_status(:created)
      |> render("show.json", order: %{order | items: order_params["items"]})
    else
      {:error, :order, %Ecto.Changeset{errors: [base: {message, []}]}, %{}} ->
        handle_bad_request(conn, message)
      {:error, :order, message} ->
        handle_bad_request(conn, message)
    end
  end

  defp handle_bad_request(conn, message) do
    conn
        |> put_status(:bad_request)
        |> put_view(BenefitsWeb.ErrorView)
        |> render("400.json", message: message)
  end
end
