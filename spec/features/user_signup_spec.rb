require "rails_helper"

RSpec.feature "User Signup" do

  scenario "cannot sign up with a taken email address" do
    User.create(name: "Jorge", email: "jorge@example.com", password: "password")

    expect do
      visit "/"
      click_link_or_button("Sign Up As Lender")
      within("#lenderSignUpModal") do
        fill_in("user[name]", with: "Richard")
        fill_in("user[email]", with: "jorge@example.com")
        fill_in("user[password]", with: "password")
        fill_in("user[password_confirmation]", with: "password")
        click_link_or_button("Create Account")
      end
    end.to_not change { User.count }

    expect(page).to have_content("Email has already been taken")
  end

  context "as a lender" do
    scenario "can sign up with valid information" do
      expect do
        visit "/"
        click_link_or_button("Sign Up As Lender")
        within("#lenderSignUpModal") do
          fill_in("user[name]", with: "Richard")
          fill_in("user[email]", with: "richard@example.com")
          fill_in("user[password]", with: "password")
          fill_in("user[password_confirmation]", with: "password")
          click_link_or_button("Create Account")
        end
      end.to change{ User.count }.from(0).to(1)

      user = User.first
      expect(user.name).to eq("Richard")
      expect(user.role).to eq("lender")
      expect(current_path).to eq(lender_path(user))
    end
  end

  context "as a borrower" do
    scenario "can sign up with valid information" do
      expect do
        visit "/"
        click_link_or_button("Sign Up As Borrower")
        within("#borrowerSignUpModal") do
          fill_in("user[name]", with: "Sally")
          fill_in("user[email]", with: "sally@example.com")
          fill_in("user[password]", with: "password")
          fill_in("user[password_confirmation]", with: "password")
          click_link_or_button("Create Account")
        end
      end.to change{ User.count }.from(0).to(1)

      user = User.first
      expect(user.name).to eq("Sally")
      expect(user.role).to eq("borrower")
      expect(current_path).to eq(borrower_path(user))
    end

    scenario "can not sign up without password confirmation" do
      expect do
        visit "/"
        click_link_or_button("Sign Up As Borrower")
        within("#borrowerSignUpModal") do
          fill_in("user[name]", with: "Sally")
          fill_in("user[email]", with: "sally@example.com")
          fill_in("user[password]", with: "password")
          click_link_or_button("Create Account")
        end
      end.to_not change{ User.count }
    end
  end
end
