require 'rails_helper'

RSpec.describe 'StocksController', type: :request do

  describe "GET /top_ten" do
    before do
      sign_in create(:user)
    end
    it "returns json with 10 items" do
      get '/top_ten'

      expect(response).to have_http_status(:success)
      result = JSON.parse(response.body)
      expect(result.count).to eq(10)
    end

  end

  describe "POST /stock_info" do
    before do
      sign_in create(:user)
    end

    it "returns the name of the company" do
      post '/stock_info', params: {stock: {ticker: "AMZN"}}

      expect(response).to have_http_status(200)
      stockInfo = JSON.parse(response.body)
      expect(stockInfo["company_name"]).to eq("Amazon.com Inc.")
    end

  end

  describe "GET /stocks" do
    before do
      @user = create(:user)
      sign_in @user
    end
    
    let!(:stock1) {Stock.create!(ticker: "AAPL")}
    let!(:transactionBuy) {Transaction.create!(user_id: @user.id, stock_id: stock1.id, share_price: 10, count: 1, gains: 0.0, total_amount: 10, transaction_type: "buy" )}

    it "returns the stocks of the current user" do
      get "/stocks"
      result = JSON.parse(response.body)
      expect(result.count).to eq(1)
    end

  end

end