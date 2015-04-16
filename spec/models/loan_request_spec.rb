require "rails_helper"

RSpec.describe LoanRequest, type: :model do

  let(:loan_request) {
    LoanRequest.new(title: "Farm Tools",
                    description: "help out with the farm tools",
                    amount: "100",
                    requested_by_date: "2015-06-01",
                    repayment_begin_date: "2015-12-01",
                    repayment_rate: "monthly",
                    contributed: "30")
  }

  context "with invalid attributes" do
    it "is invalid without any attributes" do
      loan_request = LoanRequest.new
      expect(loan_request).to_not be_valid
    end

    it "is invalid without a title" do
      loan_request.title = ""
      expect(loan_request).to_not be_valid
    end

    it "is invalid without a description" do
      loan_request.description = ""
      expect(loan_request).to_not be_valid
    end

    it "is invalid without an amount" do
      loan_request.amount = ""
      expect(loan_request).to_not be_valid
    end

    it "is invalid without a requested by date" do
      loan_request.requested_by_date = ""
      expect(loan_request).to_not be_valid
    end

    it "is invalid without a repayment begin date" do
      loan_request.repayment_begin_date = ""
      expect(loan_request).to_not be_valid
    end

    it "is invalid without a repayment rate" do
      loan_request.repayment_rate = ""
      expect(loan_request).to_not be_valid
    end

    it "is invalid without a contributed field" do
      loan_request.contributed = ""
      expect(loan_request).to_not be_valid
    end
  end

  context "valid attributes" do
    it "is valid" do
      loan_request.save
      expect(loan_request).to be_valid
    end

    it "belongs to a category" do
      loan_request.save
      loan_request.categories.create(title: "Agriculture", description: "Farm animals and an eventual meal")
      expect(loan_request.categories.first.title).to eq("Agriculture")
    end

    it "belongs to a user" do
      user = User.create(name: "Josh", email: "josh@example.com", password: "password", role: "borrower")
      expect(user.loan_requests.count).to eq(0)

      user.loan_requests.create(title: "Farm Tools",
                                description: "help out with the farm tools",
                                amount: "100",
                                requested_by_date: "2015-06-01",
                                repayment_begin_date: "2015-12-01",
                                repayment_rate: "monthly",
                                contributed: "30")

      expect(user.loan_requests.count).to eq(1)
      expect(LoanRequest.first.user_id).to eq(user.id)
    end
  end

  it "displays remaining funding amount" do
    loan_request.save

    expect(loan_request.funding_remaining).to eq(70)
  end

  describe "#funding_remaining" do
    it "returns difference of loan request's amount and contributed" do
      expect(loan_request.funding_remaining).to eq(70)
    end
  end

  describe ".projects_with_contributions" do
    it "returns only projects that have been contributed to" do
      LoanRequest.create(title: "Parm Tools",
                         description: "help out with the farm tools",
                         amount: "100",
                         requested_by_date: "2015-06-01",
                         repayment_begin_date: "2015-12-01",
                         repayment_rate: "monthly",
                         contributed: "0")

      LoanRequest.create(title: "sharp Tools",
                         description: "help out with the farm tools",
                         amount: "100",
                         requested_by_date: "2015-06-01",
                         repayment_begin_date: "2015-12-01",
                         repayment_rate: "monthly",
                         contributed: "30")

      LoanRequest.create(title: "Farm Tools",
                         description: "help out with the farm tools",
                         amount: "100",
                         requested_by_date: "2015-06-01",
                         repayment_begin_date: "2015-12-01",
                         repayment_rate: "monthly",
                         contributed: "30")

      expect(LoanRequest.projects_with_contributions.size).to eq(2)
    end
  end

  describe "#minimum_payment" do
    context "when repayment rate is monthly" do
      it "divides contributed amount by 3 (3 months) with no repayments made" do
        expect(loan_request.minimum_payment).to eq(30 / 3)
      end

      it "divides correctly if a borrower has made a payment" do
        loan_request.repayed = 10
        loan_request.save

        x = (30 - 10) / 3
        expect(loan_request.minimum_payment).to eq(x)
      end
    end

    context "when repayment rate is weekly" do
      it "divides contributed amount by 12 (3 months) with no repayments made" do
        loan_request.repayment_rate = "weekly"
        loan_request.save

        expect(loan_request.minimum_payment).to eq(30 / 12)
      end

    it "divides correctly if a borrower has made a payment" do
        loan_request.repayment_rate = "weekly"
        loan_request.repayed = 10
        loan_request.save

        x = (30 - 10) / 12
        expect(loan_request.minimum_payment).to eq(x)
      end
    end
  end
end
