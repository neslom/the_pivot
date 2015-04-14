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

  xscenario "visit portfolio and see link to pay back loan" do
    visit portfolio_path

    click_link_or_button("$$$")
    expect(current_path).to eq(borrower_path(borrower))
  end
end
