class LoanRequestsContributor < ActiveRecord::Base
  belongs_to :loan_request
  belongs_to :user

  def self.lender_contribution(user_id, loan_request)
    where(user_id: user_id, loan_request_id: loan_request.id)
  end
end
