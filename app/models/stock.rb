class Stock < ApplicationRecord
  has_many :transactions
  has_many :users, through: :transactions


  def self.get_iex 
    @stocks = IEX::Api::Client.new(
      publishable_token: 'pk_d64131df4e354bbba8ad2a863a0a8213',
      secret_token: 'sk_96fd444ed6c4419caba4651eee417039',
      endpoint: 'https://cloud.iexapis.com/v1'
    )
  end

  def self.top_ten
    get_iex.stock_market_list(:mostactive)
  end

  def hello
    puts "hello #{ticker}"
  end

end
