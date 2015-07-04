class UserBooksController < ApplicationController
  before_action :require_user, only: [:create, :destroy]

  def create
    user_book = UserBook.find_or_initialize_by(user_id: params[:user_book][:user_id], book_id: params[:user_book][:book_id])
    user_book.update_attributes!(status: params[:user_book][:status])
    redirect_to :back
  end

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