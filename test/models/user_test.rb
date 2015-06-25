require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should follow and unfollow a user" do
    michael = User.create(first_name: "Joe")
    archer  = User.create(first_name: "Judy")
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

end