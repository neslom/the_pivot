require "rails_helper"

RSpec.feature "unauthenticated user browses loan requests" do
  let (:user) { User.create(email: "jorge@example.com",
                            password: "password",
                            name: "jorge")
  }
  let (:user2) { User.create(email: "jeff@example.com",
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
                                           user_id: user2.id)
  }
  before(:each) { visit browse_path }

  scenario "can view the loan requests" do
    expect(current_path).to eq(browse_path)
    expect(page).to have_content(loan_request.title)
    expect(page).to have_content(loan_request.progress_percentage)
  end

  scenario "can view an individual item" do
    click_link_or_button "About"
    expect(page).to have_content(loan_request.title)
  end

  scenario "can add an item to the cart" do
    click_link_or_button "Contribute $25"
    expect(page).to have_content("#{loan_request.title} Added to Basket")
    visit cart_path
    expect(page).to have_content(loan_request.title)
  end

  scenario "can see the navbar updated when the cart is updated" do
    expect(page).to have_content("Basket 0")
    click_link_or_button "Contribute $25"
    expect(page).to have_content("Basket 1")
  end

  scenario "does not see Transfer Funds link if cart is empty" do
    visit cart_path
    expect(page).to_not have_link("Transfer Funds")
    expect(page).to have_content("Your Basket is Empty")
  end

  scenario "can not submit order without logging in" do
    click_link_or_button "Contribute $25"
    visit cart_path
    click_link_or_button "Transfer Funds"
    expect(page).to have_content("Please Log In to Finalize Contribution")
    expect(current_path).to eq(cart_path)
  end

  scenario "loan requests stay in cart after log in" do
    click_link_or_button "Contribute $25"
    login_as(user)
    expect(page).to have_content("Welcome to Keevahh, #{user.name}!")
    expect(current_path).to eq(browse_path)
    visit cart_path
    expect(page).to have_content(loan_request.title)
  end

  scenario "loan request can be removed from basket" do
    click_link_or_button "Contribute $25"
    visit cart_path
    expect(page).to have_content(loan_request.title)
    click_link_or_button "Remove from Basket"
    expect(page).to_not have_content(loan_request.title)
  end

  scenario "loan request amount can be incremented or decremented by $25" do
    click_link_or_button "Contribute $25"
    visit cart_path
    expect(page).to have_content("$25")
    within(".add25") do
      click_link_or_button "$25"
    end
    expect(page).to have_content("$50")
    within(".sub25") do
      click_link_or_button "$25"
    end
    expect(page).to have_content("$25")
  end

  scenario "loan request is removed if the amount is reduced to 0" do
    click_link_or_button "Contribute $25"
    visit cart_path
    expect(page).to have_content("$25")
    within(".sub25") do
      click_link_or_button "$25"
    end
    expect(page).to have_content("Your Basket is Empty")
  end

  scenario "can lend to a loan request from individual show page" do
    click_link_or_button "About"
    expect(page).to have_content("Basket 0")
    click_link_or_button "Contribute $25"
    expect(page).to have_content("Basket 1")
    click_link_or_button "Basket"
    expect(page).to have_content(loan_request.title)
  end
end
