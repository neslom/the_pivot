require "rails_helper"

RSpec.feature "unauthenticated user browses loan requests" do
  let(:create_item) { LoanRequest.create(title: "Farm Tools",
                                      description: "help out with the farm tools",
                                      amount: "$100.00",
                                      requested_by_date: "2015-06-01",
                                      repayment_begin_date: "2015-12-01",
                                      repayment_rate: "Monthly")
                    }
    scenario "can view the loan requests" do
      create_item
      visit "/browse"
      expect(current_path).to eq(browse_path)
      expect(page).to have_content("Farm Tools")
    end

    xscenario "can view an individual item" do
      create_item
      visit "/browse"
      click_link_or_button "About"
      # loan request show page
    end

    scenario "can add an item to the cart" do
      create_item
      visit "browse"
      click_link_or_button "Add to Cart"
      visit "/cart"
      expect(page).to have_content("Farm Tools")
    end
end
