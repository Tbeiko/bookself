class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user, :logged_in?, :require_user, :bad_image?, :book_count, :current_user_profile?, :require_admin!, :sort_users_by_followers, :random_color
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in? 
    !!current_user
  end

  def sort_users_by_followers
    User.all.sort_by {|user| user.followers.count}.reverse!
  end

  private

  def require_user
    if !logged_in?
      redirect_to root_path
    end
  end

  def require_admin!
    unless current_user && ((current_user.email == ENV["ADMIN1_EMAIL"]) || (current_user.email == ENV["ADMIN2_EMAIL"]) )
      redirect_to root_path
    end
  end

  def bad_image?(n)
    if @covers.items[n].get('LargeImage/URL').nil?
      true
    elsif (FastImage.size(@covers.items[n].get('LargeImage/URL'))).nil?
      true
    elsif (FastImage.size(@covers.items[n].get('LargeImage/URL'))[0]) < 200
      true
    else
      false
    end
  end

  def book_count(user)
    if logged_in?
      count = current_user.number_of_same_books(user)
      return "#{pluralize(count, 'book')} in common"
    else
      count = user.books.count
      return "#{pluralize(count, 'book')}"
    end
  end

  def current_user_profile?
    if    logged_in? && params[:id] == current_user.slug
      true
    elsif logged_in? && !params[:user_book].nil? && params[:user_book][:user_id] == current_user.id.to_s
      true
    else
      false
    end
  end

  def random_color
    ["#80b891", "#f89f81", "#586576", "#f0d2a8"].sample
  end
end
