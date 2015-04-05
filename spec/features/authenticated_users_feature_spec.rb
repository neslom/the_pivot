require "rails_helper"

RSpec.feature "Authenticated user", type: :feature do
  xcontext "authenticated user is logged in" do
    let(:user) { User.create(full_name: "Stan Smith",
                             email: "stan@abc.com",
                             password: "password",
                             display_name: "Stan Smith")}



    scenario "can log out" do
      visit '/login'
      fill_in('session[email]', with: user.email)
      fill_in('session[password]', with: user.password)
      click_link_or_button 'Login'
      click_link_or_button 'Logout'

      expect(current_path).to eq(root_path)
      expect(@current_user).to eq(nil)
    end

    scenario "cannot view the administrator screens" do
      visit '/login'
      fill_in('session[email]', with: user.email)
      fill_in('session[password]', with: user.password)
      click_link_or_button 'Login'
      visit '/admin'

      expect(page).to_not have_content('admin')

    end

    scenario "a user cannot create items" do
      visit 'admin/items/new'
      expect(page).to have_content('Not quite yet young grasshopper')
    end

    scenario "a user cannot create categories" do
      visit 'admin/categories/new'
      expect(page).to have_content('Not quite yet young grasshopper')
    end

  end
end
