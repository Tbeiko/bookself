class BooksController < ApplicationController
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
    @book = Book.new(book_params)
    
    # Will need to update this when we'll have more users
    @book.users << User.find_by(id: 1)

    if @book.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

    def book_params
      params.require(:book).permit(:title, :authors, :amazon_link, :asin, :cover_image_link)
    end
end