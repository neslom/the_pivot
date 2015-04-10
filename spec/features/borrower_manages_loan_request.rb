require "rails_helper"

RSpec.feature "borrower manages loan request" do
  let(:borrower) { User.create(name: "Richard",
                               email: "richard@example.com",
                               password: "password",
                               role: "borrower")
  }

  let(:lender) { User.create(name: "Rachel",
                             email: "rachel@example.com",
                             password: "password",
                             role: "lender")
  }

  let!(:category) { Category.create(title: "agriculture", description: "agri stuff") }

  def create_loan_request(title, description, amount, category)
    click_link_or_button "Create Loan Request"

    fill_in "Title", with: title
    fill_in "Description", with: description
    fill_in "Amount", with: amount
    find("#loan_request_requested_by_date").set("06/01/2015")
    find("#loan_request_repayment_begin_date").set("06/01/2015")
    select(category, from: "loan_request[category]")

    click_link_or_button "Submit"
  end

  before(:each) do
    visit "/"
    login_as(borrower)
  end

  scenario "creates loan request with valid info" do
    expect(current_path).to eq(borrower_path(borrower))

    create_loan_request("Farm Tools", "Help me buy some tools", "100", "Agriculture")

    expect(current_path).to eq(borrower_path(borrower))
    expect(page).to have_content("Loan Request Created")
    expect(page).to have_link("Details", href: loan_request_path(LoanRequest.first))
  end

  scenario "cannot create a loan request with invalid info" do
    create_loan_request("", "Help", "", "Agriculture")

    expect(current_path).to eq(borrower_path(borrower))
    expect(page).to have_content("Title can't be blank and Amount can't be blank")
  end

  scenario "sees contributions to a loan request" do
    borrower.loan_requests.create(title: "Farm Tools",
                                  description: "help out with the farm tools",
                                  amount: "100",
                                  requested_by_date: "2015-06-01",
                                  repayment_begin_date: "2015-12-01",
                                  repayment_rate: "monthly",
                                  contributed: "30")

    loan_request = borrower.loan_requests.first
    loan_request.categories << Category.find_by(title: "agriculture")
    visit loan_request_path(loan_request)

    expect(loan_request.contributed).to eq(30)
    expect(page).to have_content("$30.00")
  end
end
