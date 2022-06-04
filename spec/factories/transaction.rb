FactoryBot.define do
  factory(:transaction) do
    count { 2 }
    transaction_type { "buy" }
    stock {Stock.first || association(:stock, ticker: "AMZN")}
    share_price { 2 }
  end
end