class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum transaction_type: [:buy, :sell]
end
