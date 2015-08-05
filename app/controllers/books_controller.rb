class BooksController < ApplicationController
  before_action :set_user
  before_action :require_user

  def new
    @book = Book.new
    search_term = params[:book_info]
    @books  = Amazon::Ecs.item_search(search_term, { :search_index => 'Books', 
                                                     :sort => 'relevancerank' })
    @covers = Amazon::Ecs.item_search(search_term, { :response_group => 'Images',
                                                     :search_index => 'Books',
                                                     :sort => 'relevancerank' })
    render :new
  end

  def create
    @book = Book.find_by(amazon_link: params[:book][:amazon_link]) 

    if @book.nil?
      @book = Book.new(book_params)
    end

    @book.add_to_user(current_user, params[:user_book][:status])

    if @book.save
      redirect_to user_path(current_user)
      flash[:success] = "#{@book.title} was added to your bookshelf."
    else
      flash[:danger] = "Something went wrong, please try again."
      render :new
    end
  end

  private
  def set_user 
    @user = current_user
  end

  def book_params
    params.require(:book).permit(:title, :authors, :amazon_link, :asin, :cover_image_link, user_books_attributes: [:status])
  end

end