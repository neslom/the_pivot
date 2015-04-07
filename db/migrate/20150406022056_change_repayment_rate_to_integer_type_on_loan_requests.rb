class ChangeRepaymentRateToIntegerTypeOnLoanRequests < ActiveRecord::Migration
  def change
    change_column :loan_requests, :repayment_rate, 'integer USING CAST(repayment_rate AS integer)', default: 0
  end
end
