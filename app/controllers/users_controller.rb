class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :edit, :followers, :following]
  before_action :require_user, only: [:edit, :update, :following, :followers]

  def index
    @popular_users  = sort_users_by_followers
    @searched_users = User.search(params[:search])
    render :layout  => 'landing'
  end
  
  def show
    case params[:tab]
    when 'books'
      if logged_in?
        @books = current_user.same_books(@user)
      else
        return_books("read")
      end
    when 'to-read'
      return_books("to-read")
    when 'following'
      following
    when 'followers'
      followers
    else
      return_books("read")
    end
  end

  def edit
    unless @user.provider == "identity"
      redirect_to root_path
    end
  end

  def update
    # Update is only available for "fake users" right now
    if @user.provider    != "identity"
      redirect_to root_path
    elsif @user.provider == "identity"
      @user.update(user_params)
      @user.image     = "#{@user.avatar.url(:medium)}"
      @user.save!
      flash[:success] = "Your profile was updated successfully."
      redirect_to user_path
    else
      flash[:danger]  = "Something went wrong. Please try again."
      render :edit
    end
  end

  def following
    @following = @user.following.sort_by do |user| 
      if current_user
        current_user.number_of_same_books(user)
      else
        user.followers.count
      end
    end
    @following.reverse!
  end

  def followers
    @followers = @user.followers.sort_by do |user| 
      if current_user
        current_user.number_of_same_books(user)
      else
        user.followers.count
      end
    end
    @followers.reverse!
  end

  private

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def return_books(status)
    @books = []
    user_books = @user.user_books.order('user_books.updated_at desc').where(status: status)
    user_books.each do |ub|
      book = Book.find_by(id: ub.book_id)
      @books << book
    end
    @books
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :description, :image, :avatar, :cover, :slug)
  end

end