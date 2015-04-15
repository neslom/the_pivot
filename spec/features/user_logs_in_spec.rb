require "rails_helper"

RSpec.describe "User logs in" do
  let(:lender) { User.create(email: "example@example.com", password: "password", name: "richard", role: 0) }
  let(:borrower) { User.create(email: "example@example.com", password: "password", name: "sally", role: 1) }

  scenario "redirects to root on 404 error" do
    visit "/markus"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Page not found")
  end

  context "with invalid log in credentials" do

    scenario "cannot log in without email or password" do
      visit "/"
      click_link_or_button "Log In"
      within(".flash") do
        expect(page).to have_content("Invalid Login")
      end
    end

    scenario "cannot log in without email" do
      visit "/"
      fill_in("session[password]", with: "pass")
      click_link_or_button "Log In"
      within(".flash") do
        expect(page).to have_content("Invalid Login")
      end
    end

    scenario "cannot log in without password" do
      visit "/"
      fill_in("session[email]", with: "example@example.com")
      click_link_or_button "Log In"
      within(".flash") do
        expect(page).to have_content("Invalid Login")
      end
    end
  end

  context "as a valid lender" do

    scenario "can log in" do
      visit "/"
      fill_in("session[email]", with: lender.email)
      fill_in("session[password]", with: lender.password)
      click_link_or_button "Log In"
      expect(page).to have_content("Welcome to Keevahh, #{lender.name}!")
      expect(current_path).to eq(root_path)
    end

    scenario "can log out" do
      visit root_path
      click_link_or_button "Login"
      fill_in("session[email]", with: lender.email)
      fill_in("session[password]", with: lender.password)
      click_link_or_button "Log In"
      click_link_or_button "Log out"

      expect(current_path).to eq(root_path)
      expect(@current_user).to eq(nil)
    end
  end

  context "as a valid borrower" do

    scenario "can log in" do
      visit "/"
      fill_in("session[email]", with: borrower.email)
      fill_in("session[password]", with: borrower.password)
      click_link_or_button "Log In"
      expect(page).to have_content("#{borrower.name}'s Projects")
    end

    scenario "cannot see log in button" do
      visit "/"
      fill_in("session[email]", with: borrower.email)
      fill_in("session[password]", with: borrower.password)
      click_link_or_button "Log In"

      expect(page).to_not have_content("Log In")
      expect(page).to have_content("Log out")
    end

    scenario "can log out" do
      visit "/"
      fill_in("session[email]", with: borrower.email)
      fill_in("session[password]", with: borrower.password)
      click_link_or_button "Log In"
      click_link_or_button "Log out"

      expect(current_path).to eq(root_path)
      expect(@current_user).to eq(nil)
    end
  end
end
