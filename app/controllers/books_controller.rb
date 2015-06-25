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

      case 
      when @covers.items[n].get('LargeImage/URL') == nil
        true
      when (FastImage.size(@covers.items[n].get('LargeImage/URL'))[0]) < 200
        true
      else
        false
      end
    end
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
    
    # Will need to update this when we'll have more users
    @book.users << current_user

    if @book.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  private

    def book_params
      params.require(:book).permit(:title, :authors, :amazon_link, :asin, :cover_image_link)
    end

end