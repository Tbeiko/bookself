require 'spec_helper'

feature "User adds a book" do 
  scenario "user adds a book to his bookshelf" do 
    visit root_path
    click_link "Sign In"

    visit user_path(user)
    page.should_have content(user.last_name)
  end

end