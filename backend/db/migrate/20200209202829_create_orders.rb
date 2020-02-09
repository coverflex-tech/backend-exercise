class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.float :total

      t.timestamps
    end

    add_index :orders, :id    
  end
end
