defmodule Coverflex.BenefitsWeb.OrderController do
  use Coverflex.BenefitsWeb, :controller

  def create(conn, _params) do
    send_resp(conn, 404, "")
  end
  
end
