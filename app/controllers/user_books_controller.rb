class UserBooksController < ApplicationController

  def destroy
    if current_user_profile?
    user_book = UserBook.find_by(user_book_params)
    user_book.destroy
    else
      flash[:danger] = "You can't do that."
    end
    redirect_to :back
  end

  private

  def user_book_params
    params.require(:user_book).permit(:user_id, :book_id, :status)
  end

  def current_user_profile?
    logged_in? && params[:user_book][:user_id] == current_user.id.to_s
  end
end