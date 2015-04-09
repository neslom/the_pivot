class AddContributedToLoanRequests < ActiveRecord::Migration
  def change
    add_column :loan_requests, :contributed, :integer, default: 0
  end
end
