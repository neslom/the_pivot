require "rails_helper"

RSpec.feature "borrower creates loan request" do
  let(:borrower) { User.create(name: "Richard", email: "richard@example.com", password: "password", role: "borrower") }

  def create_loan_request(title, description, amount, rate)
    click_link_or_button 'Create Loan Request'

    fill_in 'Title', with: title
    fill_in 'Description', with: description
    fill_in 'Amount', with: amount
    find("#loan_request_requested_by").set("06/01/2015")
    find("#loan_request_repayment_begin").set("06/01/2015")

    click_link_or_button "Submit"
  end

  scenario "creates loan request" do
    expect(LoanRequest.count).to eq(0)
    login_as(borrower)

    expect(current_path).to eq(borrower_path(borrower))
    create_loan_request("Farm Tools", "Help me buy some tools", "100", "Monthly")

    expect(LoanRequest.count).to eq(1)
    expect(page).to have_content("Loan Requested Created")
  end

  xscenario "can add an item" do
    admin_log_in
    Category.create(title: "Sushi", description: "Sushi")
    click_link_or_button "Manage Items"
    click_link_or_button "Add Item"
    add_new_item "Sushi Roll", "A Roll Of Sushi", 8.45
    expect(page).to have_content("Sushi Roll")
  end

  context "can modify an item's attributes" do
    xscenario "makes an item retired" do
      admin_log_in
      create(:item)
      click_link_or_button "Manage Items"
      click_link_or_button "Edit Item"
      click_link_or_button "Retire Item"
      click_link_or_button "View Item"
      expect(page).to have_content("retired")
    end

    xscenario "can modify an item's attributes" do
      admin_log_in
      create(:item)
      click_link_or_button "Manage Items"
      click_link_or_button "Edit Item"
      # save_and_open_page
      fill_in("item[title]", with: "SUSHI ALL CAPS")
      expect(page).to have_content("SUSHI ALL CAPS")
    end
  end
end
