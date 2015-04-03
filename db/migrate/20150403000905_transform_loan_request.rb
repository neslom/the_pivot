class TransformLoanRequest < ActiveRecord::Migration
  def change
    rename_column :loan_requests, :price, :amount
    add_column :loan_requests, :requested_by_date, :date
    add_column :loan_requests, :repayment_begin_date, :date
    add_column :loan_requests, :repayment_rate, :text
  end
end
