require 'spec_helper'

describe UserBooksController do 
  describe "GET create" do 
    it "redirects to the home page if there is no logged in user" do 
      post :create
      expect(response).to redirect_to root_path
    end

    context "with logged in user" do 
      let(:user) { Fabricate(:user) }
      let(:book) { Fabricate(:book) }

      before do 
        session[:user_id] = user.id
        request.env["HTTP_REFERER"] = "where_i_came_from"
      end

      it "creates a new user_book record if the user has never added that books" do 
        post :create, user_book: { user_id: user.id, book_id: book.id }
        expect(UserBook.count).to eq(1)
      end

      it "updates the status of the user_book record if the user has already added that book" do 
        post :create, user_book: { user_id: user.id, book_id: book.id, status: "read" }
        post :create, user_book: { user_id: user.id, book_id: book.id, status: "to-read" }
        expect(UserBook.count).to eq(1)
      end

      it "sets the notice if the book is added" do 
        # This method still needs some work. Will TDD it.
      end

      it "redirects back to where the user came from" do 
        post :create, user_book: { user_id: user.id, book_id: book.id, status: "to-read" }
        expect(response).to redirect_to "where_i_came_from" 
      end 
    end
  end
end