class PaymentController < ApplicationController
  def update
    loan_request = LoanRequest.find(params[:id])
    if loan_request.pay!(params[:payment].to_i, current_user)
      flash[:notice] = "Thank you for your payment. You have #{loan_request.remaining_payments} left."
      redirect_to portfolio_path
    else
      flash[:error] = loan_request.errors.full_messages.to_sentence
      render :portfolio_path
    end
  end
end
