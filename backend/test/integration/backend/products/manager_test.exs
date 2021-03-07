defmodule Integration.Backend.Products.ManagerTest do
  use Backend.DataCase, async: true
  alias Backend.Products.{Manager, Product}

  describe "get/0" do
    test "should return all products" do
      # Arrange
      Repo.insert(%Product{id: "id1", name: "name1", price: 1})
      Repo.insert(%Product{id: "id2", name: "name2", price: 2})
      Repo.insert(%Product{id: "id3", name: "name3", price: 3})

      # Act
      actual = Manager.get()

      # Assert
      assert [
               %Product{id: "id1", name: "name1", price: 1},
               %Product{id: "id2", name: "name2", price: 2},
               %Product{id: "id3", name: "name3", price: 3}
             ] = actual
    end
  end

  describe "get/1" do
    setup do
      Repo.insert(%Product{id: "id1", name: "name1", price: 1})
      Repo.insert(%Product{id: "id2", name: "name2", price: 2})
      Repo.insert(%Product{id: "id3", name: "name3", price: 3})

      :ok
    end

    test "should return products by id" do
      # Arrange

      # Act
      actual = Manager.get(["id1", "id3"])

      # Assert
      assert [
               %Product{id: "id1", name: "name1", price: 1},
               %Product{id: "id3", name: "name3", price: 3}
             ] = actual
    end

    test "should return empty list if no products are found" do
      # Arrange

      # Act
      actual = Manager.get(["id4"])

      # Assert
      assert [] = actual
    end

    test "should return partial list if a subset of the ids was found" do
      # Arrange

      # Act
      actual = Manager.get(["id1", "id4"])

      # Assert
      assert [%Product{id: "id1", name: "name1", price: 1}] = actual
    end

    test "should fail if product doesn't exist" do
      # Arrange

      # Act
      actual = Manager.get("id4")

      # Assert
      assert {:error, :invalid_product_id} = actual
    end
  end
end
