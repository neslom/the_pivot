class LoanRequestsCategory < ActiveRecord::Base
  belongs_to :loan_request
  belongs_to :category
end
