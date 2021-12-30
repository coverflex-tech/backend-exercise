defmodule Coverflex.Benefits.Repo.Migrations.AddTestUserProducts do
  use Ecto.Migration
  
  alias Coverflex.Benefits.Repo
  alias Coverflex.Benefits.User
  alias Coverflex.Benefits.Product
  alias Coverflex.Benefits.UserProduct

  def change do
    subscribe_no_order = fn user_id, product_id ->
      %User{id: user_db_id} = Repo.get_by(User, user_id: user_id)
      %Product{id: product_db_id} = Repo.get_by(Product, product_id: product_id)
      Repo.insert! %UserProduct{user_id: user_db_id, product_id: product_db_id}
    end
    
    subscribe_no_order.("user1", "gym")
    subscribe_no_order.("user1", "calm")
    subscribe_no_order.("user1", "netflix")
    subscribe_no_order.("user2", "fine_foods")
    subscribe_no_order.("user3", "dental_extended")
    subscribe_no_order.("user3", "gym")
  end
end
