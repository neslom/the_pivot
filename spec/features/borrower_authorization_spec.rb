require 'rails_helper'

RSpec.feature "only authorized borrower can create or edit loan requests" do
  let!(:borrower_1) { User.create(name: "Richard",
                                  email: "richard@example.com",
                                  password: "password",
                                  role: "borrower")
  }

  let!(:borrower_2) { User.create(name: "Sally",
                                  email: "sally@example.com",
                                  password: "password",
                                  role: "borrower")
  }

  before(:each) do
    borrower_1.loan_requests.create(title: "Farm Tools",
                                    description: "help out with the farm tools",
                                    amount: "100",
                                    contributed: "50",
                                    requested_by_date: "2015-06-01",
                                    repayment_begin_date: "2015-12-01",
                                    repayment_rate: "monthly")

    borrower_2.loan_requests.create(title: "Laundry Machine",
                                    description: "help out with the laundry",
                                    amount: "100",
                                    contributed: "50",
                                    requested_by_date: "2015-06-01",
                                    repayment_begin_date: "2015-12-01",
                                    repayment_rate: "weekly")
  end

  context "unauthenticated user" do
    scenario "visits borrower page and does not see create or edit links" do
      visit borrower_path(borrower_1)

      expect(page).to_not have_link("Create Loan Request")
      expect(page).to_not have_link("Edit")

      loan_request = borrower_1.loan_requests.first
      expect(page).to have_link("About", href: loan_request_path(loan_request))
    end
  end

  context "authenticated borrower" do
    scenario "visits another borrower's page and does not see create or edit links" do
      set_current_user(borrower_1)
      visit borrower_path(borrower_2)
      loan_request = borrower_2.loan_requests.first

      expect(page).to_not have_link("Create Loan Request")
      expect(page).to have_link("About", href: loan_request_path(loan_request))
    end
  end

  context "authorized borrower" do
    let!(:loan_request) { borrower_1.loan_requests.first }

    before(:each) do
      set_current_user(borrower_1)
      visit borrower_path(borrower_1)
    end

    scenario "visits own page and sees create and edit links" do
      expect(page).to have_link("Create Loan Request")
      expect(page).to have_link("Edit", href: edit_loan_request_path(loan_request))
    end
  end
end
