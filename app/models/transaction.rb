class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum transaction_type: [:buy, :sell]
  validates :stock_id, presence: true
  validates :user_id, presence: true
  validates :transaction_type, presence: true, inclusion: { in: %w(buy sell)}
end