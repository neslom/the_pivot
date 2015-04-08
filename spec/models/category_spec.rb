require "rails_helper"

RSpec.describe Category, type: :model do

  context "invalid attributes" do
    it "is invalid without a title" do
      category = Category.create(description: "new_cat")
      expect(category).to_not be_valid
    end

    it "is invalid without a description" do
      category = Category.create(title: "new_cat")
      expect(category).to_not be_valid
    end

    it "cannot have duplicate names" do
      Category.create(title: "new_cat", description: "hello")
      expect { Category.create!(title: "new_cat", description: "hello") }.
        to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "valid attributes" do
    it "is valid" do
      category = Category.new(title: "new_cat", description: "cat")
      expect(category).to be_valid
    end

    it "has a collection of loan requests" do
      category = Category.create(title: "new_cat", description: "cat")
      category.loan_requests.create(title: "Farm Tools",
                                    description: "help out with the farm tools",
                                    amount: "100",
                                    contributed: "50",
                                    requested_by_date: "06/01/2015",
                                    repayment_begin_date: "12/01/2015",
                                    repayment_rate: "monthly")

      category.loan_requests.create(title: "Parm Tools",
                                    description: "help out with the farm tools",
                                    amount: "100",
                                    contributed: "50",
                                    requested_by_date: "06/01/2015",
                                    repayment_begin_date: "12/01/2015",
                                    repayment_rate: "monthly")

      expect(category.loan_requests.count).to eq(2)
    end
  end

end
