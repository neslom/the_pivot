class CreateLoanRequestsContributors < ActiveRecord::Migration
  def change
    create_table :loan_requests_contributors do |t|
      t.references :user, index: true
      t.references :loan_request, index: true
      t.integer :contribution
    end
  end
end
