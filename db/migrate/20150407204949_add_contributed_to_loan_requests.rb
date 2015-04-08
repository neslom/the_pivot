class AddContributedToLoanRequests < ActiveRecord::Migration
  def change
    add_column :loan_requests, :contributed, :integer
  end
end
