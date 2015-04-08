def login_as(user)
  click_link_or_button("Login")

  fill_in "session[email]", with: user.email
  fill_in "session[password]", with: user.password

  click_link_or_button "Log In"
end

def set_current_user(user)
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
end
