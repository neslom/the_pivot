require "rails_helper"

RSpec.feature "borrower dashboard" do
  let!(:borrower) { User.create(email: "jeff@example.com",
                                password: "password",
                                name: "jeff",
                                role: 1)
  }

  scenario "borrower clicks a link to view her portfolio" do
    visit "/"
    login_as(borrower)

    click_link_or_button("Portfolio")
    expect(current_path).to eq(portfolio_path)
  end
end
