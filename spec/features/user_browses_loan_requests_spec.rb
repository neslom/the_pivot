require "rails_helper"

RSpec.feature "unauthenticated user browses loan requests" do
  let (:user) { User.create(email: "jorge@example.com",
                            password: "pass",
                            name: "jorge")
  }
  let(:create_item) { LoanRequest.create(title: "Farm Tools",
                                         description: "help out with the farm tools",
                                         amount: "$100.00",
                                         requested_by_date: "2015-06-01",
                                         repayment_begin_date: "2015-12-01",
                                         repayment_rate: "monthly",
                                         user_id: user.id)
  }
  scenario "can view the loan requests" do
    create_item
    visit "/browse"
    expect(current_path).to eq(browse_path)
    expect(page).to have_content("Farm Tools")
  end

  scenario "can view an individual item" do
    create_item
    visit "/browse"
    click_link_or_button "About"
    expect(page).to have_content("Farm Tools")
  end

  scenario "can add an item to the cart" do
    create_item
    visit "browse"
    click_link_or_button "Contribute $25"
    visit "/cart"
    expect(page).to have_content("Farm Tools")
  end

  scenario "can not submit order without logging in" do
    create_item
    visit "browse"
    click_link_or_button "Contribute $25"
    visit "/cart"
    click_link_or_button "Transfer Funds"
    expect(page).to have_content("Please Log In to Finalize Contribution")
    expect(current_path).to eq(cart_path)
  end
end
