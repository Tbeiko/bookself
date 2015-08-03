class SessionsController < ApplicationController
  # Sessions are only for "fake users" at the moment. 
  
  before_action :require_admin!, only: :new

  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    if user
      redirect_to user_path(current_user)
    else 
      redirect_to :back
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end