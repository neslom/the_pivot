class User < ActiveRecord::Base
  has_secure_password
  validates_confirmation_of :password
  validates :password, :name, :email, presence: true
  validates :email, uniqueness: true
  enum role: %w(lender borrower admin)
  has_many :orders
  has_many :loan_requests
  has_many :loan_requests_contributors
  has_many :projects, through: :loan_requests_contributors, source: "loan_request"

  def amount_contributed
    loan_requests_contributors.sum(:contribution)
  end
end
