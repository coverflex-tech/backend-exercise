defmodule Coverflex.BenefitsWeb.OrderController do
  use Coverflex.BenefitsWeb, :controller
  
  alias Coverflex.Benefits.OrderModel
  alias Coverflex.Benefits.Money

  def create(conn, %{"order" => order_in}) do
    %{"user_id" => user_id, "items" => items} = order_in
    {status, response} = case OrderModel.create(user_id, items) do
      {:ok, order} -> 
        {200, %{"order" => 
                %{"order_id" => order.id, 
                  "data" => 
                    %{"items" => order.items,
                      "total" => Money.json_repr(order.total)}}}}
      {:error, error} -> 
        {400, %{"error" => Atom.to_string(error)}}
    end
    conn
    |> put_status(status)
    |> json(response)
  end
  
end
