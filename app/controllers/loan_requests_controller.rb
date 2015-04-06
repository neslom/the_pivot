class LoanRequestsController < ApplicationController
  before_action :set_loan_request, only: [:edit, :update, :show]

  def index
    @loan_requests = LoanRequest.all
  end

  def create
    loan_request = current_user.loan_requests.new(loan_request_params)

    if loan_request.save
      flash[:notice] = "Loan Request Created"
      redirect_to(:back)
    else
      flash[:error] = loan_request.errors.full_messages.to_sentence
      redirect_to(:back)
    end
  end

  def edit
  end

  def show
  end

  def update
    if @loan_request.update(loan_request_params)
      flash[:notice] = "Loan Request Updated"
      redirect_to loan_request_path(@loan_request)
    else
      flash[:error] = @loan_request.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def loan_request_params
    params.require(:loan_request).permit(:title,
                                         :description,
                                         :requested_by_date,
                                         :repayment_begin_date,
                                         :repayment_rate,
                                         :amount)
  end

  def set_loan_request
    @loan_request = LoanRequest.find(params[:id])
  end
end
