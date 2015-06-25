class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logged_in? 
    !!current_user
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You need to be logged in to do that."
      redirect_to root_path
    end
  end


  helper_method :current_user, :logged_in?, :require_user

end
