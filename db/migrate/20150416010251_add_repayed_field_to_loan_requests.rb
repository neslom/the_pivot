class AddRepayedFieldToLoanRequests < ActiveRecord::Migration
  def change
    add_column :loan_requests, :repayed, :integer, default: 0
  end
end
