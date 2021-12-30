defmodule Coverflex.Benefits.UserModel do

  alias Coverflex.Benefits.Repo
  alias Coverflex.Benefits.User, as: DBUser
  alias Coverflex.Benefits.Vallet
    
  defmodule User do
    @enforce_keys [:id]
    defstruct [:id, :name, vallet_balance: 0]
  end

  def create(id, name, vallet_balance \\ 0) do
    {:ok, user} = Repo.insert %DBUser{user_id: id, name: name}
    {:ok, vallet} = Repo.insert %Vallet{user_id: user.id, balance: vallet_balance}
    %User{id: user.user_id, name: user.name, vallet_balance: vallet.balance}
  end

  def get(id) do
    case Repo.get_by(DBUser, user_id: id) do
        nil -> {:error, :not_found}
        user -> 
            vallet = Repo.get_by(Vallet, user_id: user.id)
            {:ok, %User{id: user.user_id, name: user.name, vallet_balance: vallet.balance}}
    end
  end

end
