require "rails_helper"

RSpec.feature "borrower dashboard" do
  let!(:borrower) { User.create(email: "jeff@example.com",
                                password: "password",
                                name: "jeff",
                                role: 1)
  }

  let(:lender) { User.create(email: "example@example.com",
                             password: "password",
                             name: "richard",
                             role: 0)
  }

  let!(:loan_request) { LoanRequest.create(title: "Farm Tools",
                                           description: "help out with the farm tools",
                                           amount: "100",
                                           requested_by_date: "2015-06-01",
                                           repayment_begin_date: "2015-12-01",
                                           repayment_rate: "monthly",
                                           user_id: borrower.id)
  }

  let(:order) { Order.create(cart_items: { "#{loan_request.id}" => "25" }, user_id: lender.id) }

  let(:category) { Category.create(title: "agriculture", description: "agri stuff") }

  before(:each) do
    loan_request.categories << category
    visit "/"
    login_as(borrower)
  end

  scenario "borrower clicks a link to view her portfolio" do
    click_link_or_button("Portfolio")
    expect(current_path).to eq(portfolio_path)
    expect(page).to have_content("#{borrower.name}'s Portfolio")
    expect(page).to_not have_link("Lend")
  end

  scenario "message is displayed if there are no projects with contributions" do
    visit portfolio_path

    expect(page).to have_content("You have no open projects with contributions")
  end

  scenario "portfolio page has information about projects that have been contributed to" do
    order.update_contributed(lender)
    visit portfolio_path

    ["Total Funding Received",
     loan_request.updated_formatted,
     loan_request.title,
     loan_request.repayment_due_date,
     "$25.00",
     loan_request.repayment_begin,
     loan_request.repayment_rate.capitalize].each do |x|
       expect(page).to have_content(x)
     end
  end

  scenario "the basket is not shown to a logged in borrower" do
    expect(page).to_not have_link("Basket")
  end
end
