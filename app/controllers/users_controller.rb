class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:edit, :following, :followers]
  before_action :sort_users_by_followers, only: [:index]

  def index
    @searched_users = User.search(params[:search])
    render :layout => 'landing'
  end

  
  def show
    case params[:tab]
    when 'books'
      @books = current_user.same_books(@user)
    when 'following'
      following
    when 'followers'
      followers
    else
      @books = @user.books.order('user_books.created_at desc')
    end
  end

  def following
    @title = "Following"
    @users = @user.following.sort_by {|user| current_user.number_of_same_books(user)}.reverse!
  end

  def followers
    @title = "Followers"
    @users = @user.followers.sort_by {|user| current_user.number_of_same_books(user)}.reverse!
  end

  private

    def set_user
      @user = User.find_by(slug: params[:id])
    end

    def sort_users_by_followers
      @users_popular = User.all.sort_by {|user| user.followers.count}.reverse!
    end

end