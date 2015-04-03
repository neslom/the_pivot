class Category < ActiveRecord::Base
  validates :title, :description, presence: true
  has_many :loan_requests_categories
  has_many :loan_requests, :through => :loan_requests_categories
end
