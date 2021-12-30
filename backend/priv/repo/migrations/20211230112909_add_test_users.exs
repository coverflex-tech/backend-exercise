defmodule Coverflex.Benefits.Repo.Migrations.AddTestUsers do
  use Ecto.Migration
  
  alias Coverflex.Benefits.Repo
  alias Coverflex.Benefits.User
  alias Coverflex.Benefits.Vallet

  def change do
    add_user = fn id, name, balance ->
      {:ok, user} = Repo.insert %User{user_id: id, name: name}
      Repo.insert! %Vallet{user_id: user.id, balance: balance}
    end
    
    add_user.("user1", "Anton Frolov", 20000)
    add_user.("user2", "Kseniia Lebedeva", 50000)
    add_user.("user3", "Aleksandr Denisov", 0)
  end
end
