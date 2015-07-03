class BooksController < ApplicationController
  before_action :require_user, only: [:new, :create,]
  before_action :new, only: [:search]

  def show
  end

  def search
    # Amazon API
    search_term = params[:book_info]
    @books  = Amazon::Ecs.item_search(search_term, { :search_index => 'Books', :sort => 'relevancerank' })
    @covers = Amazon::Ecs.item_search(search_term, { :response_group => 'Images',
                                                     :search_index => 'Books',
                                                     :sort => 'relevancerank' })
    render :new
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.find_by(amazon_link: params[:book][:amazon_link]) 
    if @book == nil
      @book = Book.new(book_params)
    end
    
    @book.users << current_user
    @book.user_books.last.update_attributes!(status: params[:user_book][:status])
    @book.user_books.last.save

    if @book.save
      redirect_to user_path(current_user)
      flash[:success] = "#{@book.title} was added to your bookself."
    else
      flash[:danger] = "Something went wrong, please try again."
      render :new
    end
  end

  def read
    @book = Book.find_by(id: params[:book][:id])
    unless @book.users.include?(current_user)
      @book.users << current_user
    end
    ub = @book.user_books.find_by(user_id: current_user.id)
    ub.update_attributes!({status: params[:book][:user_book][:status]})
    redirect_to :back
  end

  def to_read
    @book = Book.find_by(id: params[:book][:id])
    unless @book.users.include?(current_user)
      @book.users << current_user
    end
    ub = @book.user_books.find_by(user_id: current_user.id)
    ub.update_attributes!({status: params[:book][:user_book][:status]})
    redirect_to :back 
  end

  private

    def book_params
      params.require(:book).permit(:title, :authors, :amazon_link, :asin, :cover_image_link, user_books_attributes: [:status])
    end

end