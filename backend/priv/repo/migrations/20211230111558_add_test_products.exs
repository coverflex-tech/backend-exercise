defmodule Coverflex.Benefits.Repo.Migrations.AddTestProducts do
  use Ecto.Migration
  
  alias Coverflex.Benefits.Repo
  alias Coverflex.Benefits.Product

  def change do
    {:ok, _} = Repo.insert %Product{product_id: "netflix", name: "Netflix subscription", price: 7599}
    {:ok, _} = Repo.insert %Product{product_id: "gym", name: "CrossFit gym subscription", price: 9990}
    {:ok, _} = Repo.insert %Product{product_id: "dental_extended", name: "Extended dental care", price: 40000}
    {:ok, _} = Repo.insert %Product{product_id: "fine_foods", name: "FineFoods monthly basket", price: 3499}
    {:ok, _} = Repo.insert %Product{product_id: "calm", name: "Calm wellness subscription", price: 15990}
  end
end
