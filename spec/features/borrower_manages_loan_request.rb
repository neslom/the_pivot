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

  def create_loan_request(title, description, amount)
    click_link_or_button "Create Loan Request"

    fill_in "Title", with: title
    fill_in "Description", with: description
    fill_in "Amount", with: amount
    find("#loan_request_requested_by_date").set("06/01/2015")
    find("#loan_request_repayment_begin_date").set("06/01/2015")

    click_link_or_button "Submit"
  end

  before(:each) do
    visit "/"
    login_as(borrower)
  end

  scenario "creates loan request with valid info" do
    expect(current_path).to eq(borrower_path(borrower))

    create_loan_request("Farm Tools", "Help me buy some tools", "100")

    expect(current_path).to eq(borrower_path(borrower))
    expect(page).to have_content("Loan Request Created")
    expect(page).to have_link("Details", href: loan_request_path(LoanRequest.first))
  end

  scenario "cannot create a loan request with invalid info" do
    create_loan_request("", "Help", "")

    expect(current_path).to eq(borrower_path(borrower))
    expect(page).to have_content("Title can't be blank and Amount can't be blank")
  end

  scenario "sees contributions to a loan request" do
    create_loan_request("Farm Tools", "Help me buy some tools", "100")
    click_link_or_button("Details")

    loan_request = borrower.loan_requests.first
    expect(current_path).to eq(loan_request_path(loan_request))
    expect(page).to have_content("$0.00")

    Order.create(user_id: lender.id, cart_items: { borrower.id => "25" })

    visit loan_request_path(loan_request)

    expect(page).to have_content("$25.00")
  end
end
