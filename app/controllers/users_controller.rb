class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:edit, :following, :followers]
  before_action :sort_users_by_followers, only: [:index]

  def index
    @searched_users = User.search(params[:search])
  end

  
  def show
    @books = @user.books.order('user_books.created_at desc')
  end

  def following
    @title = "Following"
    set_user
    @users = @user.following.paginate(page: params[:page])
    render '/users/_show_follow'
  end

  def followers
    @title = "Followers"
    set_user
    @users = @user.followers.paginate(page: params[:page])
    render '/users/_show_follow'
  end

  private

    def set_user
      @user = User.find_by(slug: params[:id])
    end

    def sort_users_by_followers
      @users_popular = User.all.sort_by {|user| user.followers.count}.reverse!
    end


end