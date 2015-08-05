require 'spec_helper'

feature "User adds a book" do 
  before do 
    clear_session_and_sign_in_user
    set_current_user
  end

  scenario "user adds a book to his bookshelf" do 
    go_to_profile(@current_user)
    go_to_add_a_book
    search_for_a_book
    add_first_book_result_to_bookshelf
  end

  scenario "user moves a book from his bookshelf to his to-read and back" do 
    create_and_add_book_to(@current_user)
    move_book_to_reading_list(@current_user, @book)
    move_book_to_bookshelf(@current_user, @book)
  end

  scenario "user removes a book from his bookshelf" do 
    create_and_add_book_to(@current_user)
    remove_book_from(@current_user, @book)
  end

  scenario "user removes a book from his to-read" do 
    create_and_add_book_to(@current_user)
    move_book_to_reading_list(@current_user, @book)
    remove_book_from(@current_user, @book)
  end

  scenario "user moves a book from another user's bookshelf to his bookshelf" do 
    create_another_user
    create_and_add_book_to(@other_user)
    add_book_from_other_user(@current_user, @other_user, @book)
  end

  scenario "user moves a book from another user's bookshelf to his to-read" do 
    create_another_user
    create_and_add_book_to(@other_user)
    go_to_profile(@other_user)
    click_link("Reading list")
    visit user_path(@current_user, tab: "to-read")
    page.should have_content(@book.title)
  end

  def clear_session_and_sign_in_user
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    visit '/signout'
    click_link('Sign In')
  end

  def set_current_user
    @current_user = User.find_by(email: "tim@bagel.com")
  end

  def create_another_user
    @other_user = Fabricate(:user)
  end

  def go_to_profile(user)
    visit user_path(user)
    page.should have_content(user.last_name)
  end

  def go_to_add_a_book
    click_link('ADD A BOOK')
    page.should have_content("Search for your book")
  end

  def search_for_a_book
    fill_in "book_info", with: "A million little"
    click_button "Search"
    page.should have_content("Choose your book")
  end

  def add_first_book_result_to_bookshelf
    page.first(".search-book").click
    page.should have_content("was added to your bookshelf.")
  end

  def create_and_add_book_to(user)
    @book     = Fabricate(:book)
    user_book = Fabricate(:user_book, user_id: user.id, book_id: @book.id, status: "read")
    go_to_profile(user)
    page.should have_content(@book.title)
  end

  def add_book_from_other_user(user1, user2, book, status=nil)
    go_to_profile(user2)
    click_link("Add to bookshelf")
    visit user_path(user1, tab: status)
    page.should have_content(book.title)
  end

  def move_book_to_reading_list(user, book)
    click_link("Reading list")
    go_to_profile(user)
    page.should_not have_content(book.title)
    visit user_path(user, tab: "to-read")
    page.should have_content(book.title)
  end

  def move_book_to_bookshelf(user, book)
    click_link("Add to bookshelf")
    visit user_path(user, tab: "to-read")
    page.should_not have_content(book.title)
    go_to_profile(user)
    page.should have_content(book.title)
  end

  def remove_book_from(user, book)
    click_link("Remove book")
    go_to_profile(user)
    page.should_not have_content(book.title)
  end
end