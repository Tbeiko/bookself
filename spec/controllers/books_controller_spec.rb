require 'spec_helper'

describe BooksController do 
  describe "GET new" do 
    context "with signed in user" do 
      before do  
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
      end

      it "renders the new book template" do 
        get :new
        expect(response).to render_template 'books/new'
      end
    end

    context "with unauthenticated user" do 
      it "redirects to the home page" do 
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST new" do 
    context "with signed in user" do 

      before do  
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        post :new, book_info: "book"
      end

      it "creates a new Book object and sets it in the @book variable" do 
        expect(assigns(:book)).to be_instance_of(Book)
      end

      it "passes the search_term to amazon and returns matching @books" do 
        expect(@books).not_to be_instance_of(Amazon::Ecs)
      end

      it "passes the search_term to amazon and returns matching @covers" do 
        expect(@covers).not_to be_instance_of(Amazon::Ecs)
      end

      it "renders the new book template" do 
        expect(response).to render_template 'books/new'
      end
    end

    context "with unauthenticated user" do 
      it "redirects to the home page" do 
        post :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST create" do 
    context "with signed in user" do 
      let(:current_user) { Fabricate(:user) }
      let(:book) {Fabricate(:book)}

      before do  
        session[:user_id] = current_user.id
      end

      context "with valid input" do 
        it "finds a book with the same amazon_link in the database if there is one" do 
          post :create, book: { title: "Title", authors: "An Author", amazon_link: book.amazon_link },
                        user_book: {status: "read"}
          expect(Book.last).to eq(book)
        end

        it "creates a new book if there is no book with the same amazon link in the database" do 
          random_url = "www." + Faker::Lorem.word + ".com"
          post :create, book: { title: "Another title", authors: "Another Author", amazon_link: random_url },
                        user_book: { status: "read" }
          expect(Book.last.amazon_link).to eq(random_url)
        end

        it "adds the selected book to the current user's books" do 
          post :create, book: { title: book.title, authors: book.authors, amazon_link: book.amazon_link },
                        user_book: {status: "read"}
          expect(current_user.books).to include(book)
        end

        it "fills the success notice" do 
          post :create, book: { title: book.title, authors: book.authors, amazon_link: book.amazon_link },
                        user_book: {status: "read"}
          expect(flash[:success]).not_to be_blank
        end

        it "redirects to the current user's page" do 
          post :create, book: { title: book.title, authors: book.authors, amazon_link: book.amazon_link },
                        user_book: {status: "read"}
          expect(response).to redirect_to user_path(current_user)
        end
      end

      context "with invalid input" do 
        before do 
          post :create, book: { title: book.title, authors: book.authors, amazon_link: nil },
                        user_book: {status: "read"}
        end
        it "does not add the book to the current user's books" do 
          expect(current_user.books).to be_empty
        end

        it "renders the new book template" do 
          expect(response).to render_template 'books/new'
        end

        it "fills the danger notice" do 
          expect(flash[:danger]).not_to be_blank
        end
      end
    end

    context "with unauthenticated user" do 
      it "redirects to the home page" do 
        post :create
        expect(response).to redirect_to root_path
      end
    end
  end
end

