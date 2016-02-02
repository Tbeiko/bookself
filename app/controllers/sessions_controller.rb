class SessionsController < ApplicationController
  # Sessions are only for "fake users" at the moment. 
  before_action :require_admin!, only: :new

  def new
  end

  def create
    auth_creds = request.env["omniauth.auth"]
    auth_creds = env["omniauth.auth"] unless env["omniauth.auth"].nil?
    user = User.from_omniauth(auth_creds)
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