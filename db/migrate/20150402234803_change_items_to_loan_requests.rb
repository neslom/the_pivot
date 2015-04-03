class ChangeItemsToLoanRequests < ActiveRecord::Migration
  def change
    rename_table :items, :loan_requests
  end
end
