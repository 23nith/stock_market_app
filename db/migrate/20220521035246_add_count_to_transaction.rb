class AddCountToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :count, :integer
    add_column :transactions, :transaction_type, :integer
    add_column :transactions, :share_price, :decimal, precision: 15, scale: 2 
    add_column :transactions, :total_amount, :decimal, precision: 15, scale: 2 
  end
end
