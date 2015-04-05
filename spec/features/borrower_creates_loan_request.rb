require "rails_helper"

RSpec.feature "borrower creates loan request" do
  let(:borrower) { User.create(name: "Richard",
                               email: "richard@example.com",
                               password: "password",
                               role: "borrower")
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

  scenario "creates loan request with valid info" do
    login_as(borrower)

    expect(current_path).to eq(borrower_path(borrower))

    create_loan_request("Farm Tools", "Help me buy some tools", "100")

    expect(current_path).to eq(borrower_path(borrower))
    expect(page).to have_content("Loan Request Created")
    expect(page).to have_link("About", href: loan_request_path(LoanRequest.first))
  end

  xscenario "cannot create a loan request with invalid info" do
  end
end
