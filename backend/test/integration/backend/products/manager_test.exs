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
    test "should return a product by id"
    test "should fail if product doesn't exist"
  end
end
