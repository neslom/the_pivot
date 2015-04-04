class LoanRequestsController < ApplicationController
  def index
    @loan_requests = LoanRequest.all
  end

  def create
    loan_request = current_user.loan_requests.new(loan_request_params)

    if loan_request.save
      flash[:notice] = "Loan Request Created"
      redirect_to(:back)
    else
      flash[:error] = "Failure"
      redirect_to(:back)
    end
  end

  private

  def loan_request_params
    params.require(:loan_request).permit(:title, :description, :requested_by_date,
                                         :repayment_begin_date,
                                         :repayment_rate, :amount)
  end

end
