class UserBooksController < ApplicationController
  before_action :require_user, only: [:create, :destroy]

  def create
    # This needs to be refactored
    user = User.find_by(id: params[:user_book][:user_id])
    book = Book.find_by(id: params[:user_book][:book_id])
    book_count = user.books.count
    user_book = UserBook.find_or_initialize_by(user_id: params[:user_book][:user_id], book_id: params[:user_book][:book_id])
    user_book.update_attributes!(status: params[:user_book][:status])
    post_book_count = user.books.count 
      if post_book_count > book_count
        # Need a better way to assert this
        if params[:user_book][:status] == "read"
          flash[:success] = "#{book.title} was successfully added to your bookshelf."
        elsif params[:user_book][:status] == "to-read"
          flash[:success] = "#{book.title} was successfully added to your reading list."
        end
      # Need an "else" case that works when the user only moves the book between "read" and "to-read"
      end

    redirect_to :back
  end

  def destroy
    if current_user_profile?
      book = Book.find_by(id: params[:user_book][:book_id])
      book_count = current_user.books.count
      user_book = UserBook.find_by(user_book_params)
      user_book.destroy
      post_book_count = current_user.books.count

      if post_book_count < book_count
        flash[:success] = "#{book.title} was successfully removed from your profile."
      else
        flash[:danger] = "Something went wrong. Please try again."
      end

    else
      flash[:danger] = "You can't do that."
    end
    redirect_to :back
  end

  private

  def user_book_params
    params.require(:user_book).permit(:user_id, :book_id, :status)
  end

end