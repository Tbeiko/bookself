class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user, only: [:edit, :following, :followers]

  def show
    @books = @user.books.order('user_books.created_at desc')
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render '/users/_show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render '/users/_show_follow'
  end

  private

    def set_user
      @user = User.find_by(id: params[:id])
    end
end