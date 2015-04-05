class AddUserIdToLoanRequests < ActiveRecord::Migration
  def change
    add_column :loan_requests, :user_id, :integer
    add_foreign_key :loan_requests, :users
    add_index :loan_requests, :user_id
  end
end
