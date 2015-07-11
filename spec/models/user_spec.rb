require 'spec_helper'

describe User do 
  it {should have_many(:user_books)}
  it {should have_many(:books).through(:user_books)}
  it {should have_many(:active_relationships).class_name("Relationship").with_foreign_key("follower_id").dependent(:destroy)}
  it {should have_many(:passive_relationships).class_name("Relationship").with_foreign_key("followed_id").dependent(:destroy)}
  it {should have_many(:following).through(:active_relationships).source(:followed)}
  it {should have_many(:followers).through(:passive_relationships).source(:follower)}
end