require "rails_helper"

RSpec.feature "user browses items" do
  let(:create_item) { LoanRequest.create( ) }

  context "unauthenticated user" do
    scenario "can browse the items" do
      # create(:item)
      visit "/menu"
      expect(current_path).to eq(menu_path)
      expect(page).to have_content("Sushi")
    end

    xscenario "can view an individual item" do
      # create(:item)
      visit "/menu"
      click_link_or_button "Sushi"
      expect(page).to have_content("$11.00")
      expect(page).to_not have_content("status")
    end
  end
end
