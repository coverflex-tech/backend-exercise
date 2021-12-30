defmodule Coverflex.BenefitsWeb.ProductController do
  use Coverflex.BenefitsWeb, :controller
  
  alias Coverflex.Benefits.ProductModel
  alias Coverflex.Benefits.Money

  def index(conn, _params) do
    products = ProductModel.get_all()
               |> Enum.map(&%{"id" => &1.id, 
                              "name" => &1.name,
                              "price" => Money.json_repr(&1.price)})
    json(conn, %{"products" => products})
  end
  
end
