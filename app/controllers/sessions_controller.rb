class SessionsController < ApplicationController
  
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to user_path(current_user)
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've logged out succesfully."
    redirect_to root_url
  end
end