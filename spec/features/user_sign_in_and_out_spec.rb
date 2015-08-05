require 'spec_helper'

feature "user signs in and out" do 
  before do 
    visit '/signout'
  end
  scenario "with valid input and FB omniauth" do 
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    click_link('Sign In')
    page.should have_content(User.first.first_name)
  end
end