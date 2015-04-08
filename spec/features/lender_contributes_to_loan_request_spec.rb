require "rails_helper"

RSpec.feature "lender contributes to loan request" do
  let(:lender) { User.create(email: "example@example.com",
                             password: "password",
                             name: "richard",
                             role: 0)
  }

  let!(:borrower) { User.create(email: "jeff@example.com",
                             password: "pass",
                             name: "jeff",
                             role: 1)
  }

  let!(:loan_request) { LoanRequest.create(title: "Farm Tools",
                                           description: "help out with the farm tools",
                                           amount: "100",
                                           requested_by_date: "2015-06-01",
                                           repayment_begin_date: "2015-12-01",
                                           contributed: "50",
                                           repayment_rate: "monthly",
                                           user_id: borrower.id)
  }

  scenario "transfers funds successfully" do
    visit "/"
    login_as(lender)
    visit browse_path
    click_link_or_button("Contribute $25")
    visit cart_path

    click_link_or_button("Transfer Funds")
    expect(current_path).to eq(lender_path(lender))
    expect(page).to have_content("Thank you for your contribution, #{lender.name}!")

    visit cart_path
    expect(page).to_not have_content(loan_request.title)
  end

end
