class AddBalanceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :decimal, precision: 15, scale: 2, default: 1000
  end
end
