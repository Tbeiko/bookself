require 'spec_helper'

describe User do 
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:user_books) }
  it { should have_many(:books).through(:user_books) }
  it { should have_many(:active_relationships).class_name("Relationship").with_foreign_key("follower_id").dependent(:destroy) }
  it { should have_many(:passive_relationships).class_name("Relationship").with_foreign_key("followed_id").dependent(:destroy) }
  it { should have_many(:following).through(:active_relationships).source(:followed) }
  it { should have_many(:followers).through(:passive_relationships).source(:follower) }

  describe "#follow" do 
    it "adds a user to the user's following count" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user1.follow(user2)
      expect(user1.following).to eq([user2])
    end
  end

  describe "#unfollow" do 
    it "removes a user from the user's following count" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user1.follow(user2)
      expect(user1.following.count).to eq(1)
      user1.unfollow(user2)
      expect(user1.following.count).to eq(0)
    end
  end

  describe "#search" do 
    # Not sure how to test this method.
  end

  describe "#same_books" do 
    it "returns the unique books common to both users" do 
      user         = Fabricate(:user)
      current_user = Fabricate(:user)
      book1        = Fabricate(:book)
      book2        = Fabricate(:book)
      current_user.books << book1
      user.books << book1
      user.books << book2
      expect(current_user.same_books(user)).to eq([book1])
    end
  end

  describe "#number_of_same_books" do 
    it "returns number of unique books common to both users" do 
      user         = Fabricate(:user)
      current_user = Fabricate(:user)
      book1        = Fabricate(:book)
      book2        = Fabricate(:book)
      current_user.books << book1
      user.books << book1
      user.books << book2
      expect(current_user.number_of_same_books(user)).to eq(1)
    end
  end

  describe "#to_param" do 
    it "returns the user's slug" do 
      user = Fabricate(:user)
      expect(user.to_param).to eq(user.slug)
    end
  end

  describe "#generate_slug" do 
    it "creates a slug from the user's first and last name" do 
      user = Fabricate(:user)
      user.generate_slug
      expected_slug = (user.first_name + user.last_name).downcase
      expect(user.slug).to eq(expected_slug)
    end

    it "appends a dash and number if the slug already exisits" do 
      user1 = Fabricate(:user)
      user1.generate_slug
      user2 = Fabricate(:user, first_name: user1.first_name, last_name: user1.last_name)
      user2.generate_slug
      expected_slug = (user2.first_name + user2.last_name + "-2").downcase
      expect(user2.slug).to eq(expected_slug)
    end
  end

  describe "to_slug" do
    # Not sure to test this method.
  end

  describe "random_color" do 
    # Should I test this one?
  end
end








