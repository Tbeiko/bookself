class UsersController < ApplicationController

  def show
    @user = User.find_by(id: 1)
  end

end