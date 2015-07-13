class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :edit]
  before_action :require_user, only: [:edit, :following, :followers]
  before_action :sort_users_by_followers, only: [:index]

  def index
    @searched_users = User.search(params[:search])
    render :layout => 'landing'
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

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
  end

  def edit
    unless @user.provider == "identity"
      redirect_to root_path
    end
  end

  def update
    unless @user.provider == "identity"
      redirect_to root_path
    end
    if @user.update(user_params)
      @user.image = "#{@user.avatar.url(:medium)}"
      @user.save
      flash[:success] = "Your profile was updated successfully."
      redirect_to user_path
    else
      render :edit
    end
  end

  def following
    @title = "Following"
    @following = @user.following.sort_by {|user| current_user.number_of_same_books(user)}.reverse!
  end

  def followers
    @title = "Followers"
    @followers = @user.followers.sort_by {|user| current_user.number_of_same_books(user)}.reverse!
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