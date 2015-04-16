require "rails_helper"

RSpec.feature "borrower pays back loan" do
  let!(:lender) { User.create(email: "jorge@example.com",
                              password: "password",
                              name: "jorge")
  }

  let!(:borrower) { User.create(email: "jeff@example.com",
                                password: "password",
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

  let!(:order) { Order.create(cart_items: { "#{loan_request.id}" => "25" }, user_id: lender.id) }

  let(:category) { Category.create(title: "agriculture", description: "agri stuff") }

  before(:each) do
    loan_request.categories << category
    order.update_contributed(lender)
    visit "/"
    login_as(borrower)
  end

  scenario "visit portfolio and pay back a loan" do
    visit portfolio_path

    within("tbody") do
      expect(page).to have_content("$75.00")
    end

    find_button("Submit").click

    within(".flash") do
      expect(page).to have_content("Thank you for your payment")
    end
    expect(current_path).to eq(portfolio_path)
  end

  scenario "total repayed funds are shown on the portfolio page" do
    visit portfolio_path
    find_button("Submit").click

    within(".panel-body") do
      expect(page).to have_content("$8")
    end
  end
end
