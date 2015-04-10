class AddTimestampsToLoanRequestsContributors < ActiveRecord::Migration
  def up
    change_table :loan_requests_contributors do |t|
      t.timestamps
    end
  end

  def down
    change_table :loan_requests_contributors do |t|
      t.remove_timestamps
    end
  end
end
