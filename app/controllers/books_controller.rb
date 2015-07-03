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

  # def create
  #   if Book.find_by(amazon_link: params[:book][:amazon_link]) 
  #     @book = Book.find_by(amazon_link: params[:book][:amazon_link]) 
  #     current_user.books << @book 

  #     # redirect_to current_user.books.find_by(amazon_link: params[:book][:amazon_link]).tap do |book|
  #     #   book.user_books.last.update_attributes!(book_params)
  #     #   binding.pry
  #     # end

  #     redirect_to current_account.users.find(params[:id]).tap do |user|
  #       binding.pry
  #     end

  #   # redirect_to current_account.people.find(params[:id]).tap do |person|
  #   #   person.update_attributes!(person_params)
  #   # end

  #   else @book = Book.new 
  #     @book.title = params[:book][:title]
  #     @book.authors = params[:book][:authors]
  #     @book.amazon_link = params[:book][:amazon_link]
  #     @book.asin = params[:book][:asin]
  #     @book.cover_image_link = params[:book][:cover_image_link]
  #     @book.users << current_user
  #     @book.user_books.last.status = params[:user_book][:status]
  #     @book.user_books.last.status.save
  #   end
  

  #   # if @book.save
  #   #   redirect_to user_path(current_user)
  #   #   flash[:success] = "#{@book.title} was added to your bookself."
  #   # else
  #   #   flash[:danger] = "Something went wrong, please try again."
  #   #   render :new
  #   # end
  # end

  def create
    @book = Book.find_by(amazon_link: params[:book][:amazon_link]) 
    if @book == nil
      @book = Book.new(book_params)
    end
    
    @book.users << current_user
    @book.user_books.last.update_attributes!({status: params[:user_book][:status]})
    @book.user_books.last.save
    binding.pry

    if @book.save
      redirect_to user_path(current_user)
      flash[:success] = "#{@book.title} was added to your bookself."
    else
      flash[:danger] = "Something went wrong, please try again."
      render :new
    end
  end

  def read
    book_params
    @book = Book.find_by(id: params[:id])
    @book.add_to_user(current_user, params[:book][:status])

    redirect_to :back
  end

  def to_read
  end

  private

    def book_params
      params.require(:book).permit(:title, :authors, :amazon_link, :asin, :cover_image_link, user_books_attributes: [:status])
    end

end