require "rails_helper"

RSpec.feature "borrower dashboard" do
  let!(:borrower) { User.create(email: "jeff@example.com",
                                password: "password",
                                name: "jeff",
                                role: 1)
  }

  scenario "borrower signs in and sees a link to her portfolio" do
    visit "/"
    login_as(borrower)

    expect(current_path).to eq(borrower_path(borrower))
    expect(page).to have_link("Portfolio")
  end
end
