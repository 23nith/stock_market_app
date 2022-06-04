require 'rails_helper'

RSpec.describe 'TransactionsController', type: :request do
  
  describe "GET /Transactions" do

    before do
      @user = create(:user)
      sign_in @user
    end

    let!(:stock) {Stock.create!(ticker: "AAPL")}
    let!(:transactionBuy) {Transaction.create!(user_id: @user.id, stock_id: stock.id, share_price: 10, count: 1, gains: 0.0, total_amount: 10, transaction_type: "buy" )}

    it "returns json" do
      get '/transactions'

      expect(response).to have_http_status(:success)
      transactions = JSON.parse(response.body)
      expect(transactions.count).to eq(1)

    end
  end


  describe "POST /Transactions" do

    before do
      @user = create(:user)
      sign_in @user
    end

    it "creates a new transaction" do

      expect {post "/transactions", params: {transaction: {symbol: "IBM", count: 2, transaction_type: "buy"}}}. to \
      change(Transaction, :count)
      .by(1)

      expect(response).to have_http_status(201)
      count = JSON.parse(response.body)['count']
      expect(count).to eq(2)

    end



    it 'computes for total amount of the transaction' do

      post "/transactions", params: {transaction: {symbol: "IBM", count: 2, transaction_type: "buy"}}
      
      expect(response).to have_http_status(201)
      transaction = JSON.parse(response.body)

      @total_amount = transaction["count"].to_f * transaction["share_price"].to_f

      expect(transaction["total_amount"].to_f).to eq(@total_amount)
      
    end




    let!(:stock) {Stock.create!(ticker: "AAPL")}
    let!(:transactionBuy) {Transaction.create!(user_id: @user.id, stock_id: stock.id, share_price: 10, count: 1, gains: 0.0, total_amount: 10, transaction_type: "buy" )}
    
    it "computes gains after selling for a higher price" do

      post "/transactions", params: {transaction: {symbol: "AAPL", count: 1, transaction_type: "sell"}}
      transactionSell = JSON.parse(response.body)
      
      @gains = transactionSell["share_price"].to_f - transactionBuy["share_price"].to_f

      expect(transactionSell["gains"].to_f).to eq(@gains)

    end
    
  end

end