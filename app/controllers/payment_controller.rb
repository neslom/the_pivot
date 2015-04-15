class PaymentController < ApplicationController
  def update
    loan_request = LoanRequest.find(params[:id])
  end
end
