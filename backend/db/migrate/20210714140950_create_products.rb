class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, unique: true, default: ""
      t.integer :price, null: false, default: 0

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
