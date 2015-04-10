class AddDefaultValueToLoanRequestForContributed < ActiveRecord::Migration
  def change
    change_column_default :loan_requests, :contributed, 0
  end
end
