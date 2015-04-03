class LoanRequestsCategories < ActiveRecord::Migration
  def change
    create_table :loan_requests_categories do |t|
      t.belongs_to :loan_request, index: true
      t.belongs_to :category, index: true
    end
  end
end
