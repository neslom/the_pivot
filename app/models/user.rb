class User < ActiveRecord::Base
  has_secure_password
  validates :password, :name, :email, presence: true
  enum role: %w(lender borrower admin)
  has_many :orders
end
