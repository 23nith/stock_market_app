require 'rails_helper'

RSpec.describe Stock, type: :model do
  let!(:stock) { Stock.new }

  context 'Validations' do
    it '1. is not valid without ticker' do

      expect(stock).to_not be_valid
      
    end

    let!(:stock2) {Stock.create!(ticker: "AAPL")}
    
    it '2. is not valid if ticker is a duplicate' do
      stock.ticker = "AAPL"
      expect(stock).to_not be_valid

    end
  end

end