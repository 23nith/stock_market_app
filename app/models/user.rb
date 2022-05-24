class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable, :confirmable

  enum role: [:user, :moderator, :admin]
  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end

  validates :balance, presence: true
  has_many :transactions
  has_many :stocks, through: :transactions

  # def full_name
  #   "#{first_name} #{last_name}"
  # end

end
