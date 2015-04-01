require 'rails_helper'

RSpec.describe "User Signup" do

  context "as a lender" do

    it "clicks Signup link and is taken to signup form" do
      visit '/'
      click_link_or_button("Sign Up")
      click_link_or_button("As Lender")

      expect(current_path).to eq(new_lender_path)
    end

    it "can sign up with valid information" do
      expect(User.count).to eq(0)

      visit '/'
      click_link_or_button("Sign Up")
      click_link_or_button("As Lender")

      fill_in("user[name]", with: "Richard")
      fill_in("user[email]", with: "richard@example.com")
      fill_in("user[password]", with: "password")
      fill_in("user[password_confirmation]", with: "password")
      click_link_or_button("Create my account")

      expect(User.count).to eq(1)

      user = User.first
      expect(user.name).to eq("Richard")
      expect(user.role).to eq("lender")
      expect(current_path).to eq(lender_path(user))
    end

  end
end
