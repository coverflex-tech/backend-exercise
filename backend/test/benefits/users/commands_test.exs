defmodule Benefits.Users.CommandsTest do
  use Benefits.DataCase, async: true

  import Benefits.Factory

  alias Benefits.Users.Commands

  @default_balance 20_000

  describe "create_user!/1" do
    test "creates an user with the given username and the default balance" do
      assert user = Commands.create_user!("redrum")
      assert user.username == "redrum"
      assert user.balance == @default_balance
    end
  end

  describe "decrease_user_balance!/2" do
    test "updates an user decreasing balance" do
      %{balance: balance} = user = insert(:user, balance: 10)
      debit_value = 3
      updated_user = Commands.decrease_user_balance!(user, debit_value)
      assert updated_user.balance == balance - debit_value
    end

    test "fails if decreasing balance would mean going into < 0" do
      user = insert(:user, balance: 10)
      debit_value = 11

      assert_raise(Ecto.InvalidChangesetError, fn ->
        Commands.decrease_user_balance!(user, debit_value)
      end)
    end
  end
end
