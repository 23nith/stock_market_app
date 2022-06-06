require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:transaction) { Transaction.new }
  
  context 'Validations' do
    it '1. is not valid without a stock id' do
      transaction.user_id = 1
      transaction.transaction_type = "buy"
      expect(transaction).to_not be_valid
    end

    it '2. is not valid without a user id' do
      transaction.stock_id = 1
      transaction.transaction_type = "buy"
      expect(transaction).to_not be_valid
    end

    it '3. is not valid without a transaction type' do
      transaction.stock_id = 1
      transaction.user_id = 1
      expect(transaction).to_not be_valid
    end

    it '4. is not valid if transaction is neither of the type "buy" nor "sell"' do
      transaction.stock_id = 1
      transaction.user_id = 1
      expect{transaction.transaction_type = "abcde"}.to raise_error(ArgumentError)

    end

  end
end