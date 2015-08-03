require 'spec_helper'

describe Book do 
  it { should have_many(:user_books) }
  it { should have_many(:users).through(:user_books) }
  it { should accept_nested_attributes_for :user_books }

  describe "#add_to_user" do 
    it "adds a book to the user" do 
      book = Fabricate(:book)
      user = Fabricate(:user)
      book.add_to_user(user, "read")
      expect(user.books).to include(book)
    end
  end
end