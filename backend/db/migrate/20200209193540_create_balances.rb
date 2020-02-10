class CreateBalances < ActiveRecord::Migration[6.0]
  def change
    create_table :balances do |t|

      t.integer :user_id
      t.float :amount

      t.timestamps
    end

    add_index :balances, :user_id
  end
end
