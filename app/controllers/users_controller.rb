class UsersController < ApplicationController

  def show
    @user = User.find_by(id: 3)
  end

end