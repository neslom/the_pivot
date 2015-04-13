class BorrowerPortfolioController < ApplicationController
  def show
    @borrower = current_user
    @loan_requests = @borrower.loan_requests.projects_with_contributions
  end
end
