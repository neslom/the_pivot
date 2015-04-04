class LoanRequestsController < ApplicationController
  def create
    loan_request = current_user.loan_requests.new(loan_request_params)

    if loan_request.save
      flash[:notice] = "Success!"
    else
      flash[:error] = "Failure"
      redirect_to
    end
  end

  private

  def loan_request_params
    params.require(:loan_request).permit(:title, :description, :requested_by,
                                         :repayment_begin,
                                         :repayment_rate, :amount)
  end

end
