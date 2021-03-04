defmodule Integration.Backend.Users.ManagerTest do
  use Backend.DataCase, async: true
  alias Backend.Products.Product
  alias Backend.Repo
  alias Backend.Users.{Manager, Order, User}

  @default_user_balance Application.compile_env!(:backend, [
                          :user,
                          :default_balance
                        ])

  describe "get/1" do
    test "should return a user" do
      # Arrange
      Repo.insert(%User{user_id: "user_id", balance: 10, product_ids: ["a_product_id"]})

      # Act
      actual = Manager.get("user_id")

      # Assert
      assert {:ok, %User{user_id: "user_id", balance: 10, product_ids: ["a_product_id"]}} = actual
    end

    test "should fail if user doesn't exist" do
      # Arrange

      # Act
      actual = Manager.get("some_user")

      # Assert
      assert {:error, :invalid_user_id} = actual
    end
  end

  describe "add/1" do
    test "should succeed" do
      # Arrange

      # Act
      actual = Manager.add("user_id")

      # Assert
      assert {:ok, %User{user_id: "user_id", balance: @default_user_balance, product_ids: []}} =
               actual
    end

    test "should add a user" do
      # Arrange
      user_id = "id"

      # Act
      {:ok, _user} = Manager.add(user_id)

      # Assert
      assert %User{user_id: ^user_id, balance: @default_user_balance, product_ids: []} =
               Repo.get(User, user_id)
    end

    # TODO: Currently passing despite require_length
    test "should fail if user_id is empty" do
      # Arrange

      # Act
      actual = Manager.add("")

      # Assert
      assert {:error, :stuff} = actual
    end

    test "should fail if already exists" do
      # Arrange
      user_id = "existing_user_id"
      Repo.insert(%User{user_id: user_id})

      # Act
      actual = Manager.add(user_id)

      # TODO: This raises instead of returning an error, `unique_constraint/3` doesn't work. I'm missing something

      # Assert
      assert {:error, :stuff} = actual
    end
  end

  describe "order/3" do
    setup do
      user = %User{user_id: "user_id", balance: 10, product_ids: ["id2"]}
      Repo.insert(user)
      Repo.insert(%Product{id: "id1", name: "name1", price: 1})
      Repo.insert(%Product{id: "id2", name: "name2", price: 2})
      Repo.insert(%Product{id: "id3", name: "name3", price: 3})

      {:ok, %{user: user}}
    end

    test "should succeed if valid", %{user: %User{user_id: id}} do
      # Arrange
      items = ["id1", "id3"]
      total = 4

      # Act
      actual = Manager.order(id, items, 4)

      # Assert
      assert {:ok, %Order{items: ^items, total: ^total, user_id: ^id}} = actual
    end

    test "should add an order", %{user: %User{user_id: id}} do
      # Arrange
      items = ["id1", "id3"]
      total = 4

      # Act
      {:ok, %Order{order_id: order_id}} = Manager.order(id, items, total)

      actual = Backend.Repo.get(Order, order_id)

      # Assert
      assert %Order{items: ^items, order_id: ^order_id, total: ^total, user_id: ^id} = actual
    end

    test "should update the user data", %{
      user: %User{user_id: id, balance: balance, product_ids: bought}
    } do
      # Arrange
      items = ["id1", "id3"]
      total = 5
      expected_balance = balance - total
      expected_product_ids = bought ++ items

      # Act
      {:ok, _} = Manager.order(id, items, total)

      actual = Backend.Repo.get(User, id)

      # Assert
      assert %User{product_ids: ^expected_product_ids, balance: ^expected_balance} = actual
    end

    test "should fail if the user does not exist" do
      # Arrange

      # Act
      # Republic credits?!
      actual = Manager.order("darth_maul", ["a_fancy_saber"], 0)

      # Assert
      assert {:error, :invalid_user_id} = actual
    end

    test "should fail if user does not have sufficient balance", %{
      user: %User{user_id: id, balance: balance}
    } do
      # Arrange
      items = ["id1"]
      total = balance + 1

      # Act
      actual = Manager.order(id, items, total)

      # Assert
      assert {:error, :insufficient_balance} = actual
    end

    test "should fail if user has previously bought the products", %{
      user: %User{user_id: id, product_ids: bought}
    } do
      # Arrange
      items = Enum.take(bought, 1)
      total = 0

      # Act
      actual = Manager.order(id, items, total)

      # Assert
      assert {:error, :products_already_purchased} = actual
    end
  end
end
