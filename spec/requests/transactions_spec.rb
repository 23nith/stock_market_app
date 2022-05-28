require 'rails_helper'

RSpec.describe 'TransactionsController', type: :request do
  
  describe "GET /Transactions" do
    before do
      sign_in create(:user)
    end
    it "returns json" do
      get '/transactions'

      expect(response).to have_http_status(:success)

    end
  end

  describe "POST /Transactions" do
    before do
      sign_in create(:user)
    end
    it "creates a new transaction" do
      expect {post "/transactions", params: {transaction: {symbol: "IBM", count: 2, transaction_type: "buy"}}}. to \
      change(Transaction, :count)
      .by(1)

      expect(response).to have_http_status(201)
      count = JSON.parse(response.body)['count']
      expect(count).to eq(2)
    end
  end

end