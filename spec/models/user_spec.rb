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
end