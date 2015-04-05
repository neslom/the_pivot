require 'rails_helper'

RSpec.feature "only authorized borrower can create or edit loan requests" do
  let!(:borrower) { User.create(name: "Richard",
                                email: "richard@example.com",
                                password: "password",
                                role: "borrower")
  }

  context "unauthenticated user" do
    scenario "visits borrower page and does not see create or edit links" do
      visit borrower_path(borrower)

      expect(page).to_not have_link("Create Loan Request")
      expect(page).to_not have_link("Edit")
    end
  end
end
