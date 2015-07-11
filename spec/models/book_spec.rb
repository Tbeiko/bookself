require 'spec_helper'

describe Book do 
  it {should have_many(:user_books)}
  it {should have_many(:users).through(:user_books)}
  it {should accept_nested_attributes_for :user_books}
end