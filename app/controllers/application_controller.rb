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

  def bad_image?(n)
    if @covers.items[n].get('LargeImage/URL').nil?
      true
    elsif (FastImage.size(@covers.items[n].get('LargeImage/URL'))[0]).nil?
      true
    elsif ((FastImage.size(@covers.items[n].get('LargeImage/URL'))[0]) < 200)
      true
    else
      false
    end
  end


  helper_method :current_user, :logged_in?, :require_user, :bad_image?

end
