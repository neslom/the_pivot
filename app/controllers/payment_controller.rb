class PaymentController < ApplicationController
  def update
    loan_request = LoanRequest.find(params[:id])
    if loan_request.pay!(params[:payment].to_i, current_user)
      flash[:notice] = "Thank you for your payment"
      redirect_to portfolio_path
    end
  end
end
