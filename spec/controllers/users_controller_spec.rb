require 'spec_helper'

describe UsersController do 

  describe "GET index" do 
    it "sets the @popular_users variable" do 
      get :index
      expect(assigns(:popular_users)).not_to be_nil
    end

    it "renders the layouts/landing template" do 
      get :index
      expect(response).to render_template 'layouts/landing'
    end

  end

  describe "GET show" do
    let(:user)  { Fabricate(:user) }
    let(:book)  { Fabricate(:book) }
    let(:user2) { Fabricate(:user) } 

    before do 
      user.follow(user2)
      user2.follow(user)
    end

    context "with authenticated user" do 
      let(:current_user) { Fabricate(:user) }

      before do 
        session[:user_id] = current_user.id
      end

      it "shows common books when tab is set to 'books' " do 
        user.books         << book
        current_user.books << book
        get :show, id: user.slug, tab: 'books'
        expect(assigns(:books)).to eq(current_user.same_books(user))
      end

      it "shows a user's to read books when tab is set to 'to-read' " do 
        user_book = Fabricate(:user_book, user_id: user.id, book_id: book.id, status: "to-read")
        get :show, id: user.slug, tab: 'to-read'
        expect(assigns(:books)).to eq([book])
      end

      it "shows a user's following when tab is set to 'following' " do 
        get :show, id: user.slug, tab: 'following'
        expect(assigns(:following)).to eq([user2])
      end

      it "shows a user's followers when the tab is set to 'followers' " do 
        get :show, id: user.slug, tab: 'followers'
        expect(assigns(:followers)).to eq([user2])
      end

      it "shows a user's read books when the tab is not set" do 
        Fabricate(:user_book, user_id: user.id, book_id: book.id)
        get :show, id: user.slug
        expect(assigns(:books)).to eq([book])
      end
    end

    context "with unauthenticated users" do 
      # All other behiaviors are the same for authenticated or unauthenticated users
      it "shows a user's read books when tab is set to 'books' " do 
        user_book = Fabricate(:user_book, user_id: user.id, book_id: book.id)
        get :show, id: user.slug, tab: 'books'
        expect(assigns(:books)).to eq([book])
      end
    end
  end

  describe "GET edit" do 

    it "redirects to the root path if the user's provider is not identity" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :edit, id: user.slug
      expect(response).to redirect_to root_path
    end

    it "renders the edit template if the user's provider is identity" do 
      user = Fabricate(:user, provider: "identity")
      session[:user_id] = user.id
      get :edit, id: user.slug
      expect(response).to render_template :edit
    end
  end

  describe "POST update_user" do 
    it "redirects to the root path if the user's provider is not identity" do 
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :update, id: user.slug, user: { description: "Good guy" }
      expect(response).to redirect_to root_path
    end

    context "user whose provider is 'identity' " do 
      let(:user) { Fabricate(:user, provider: "identity") }

      before do 
        session[:user_id] = user.id
      end

      it "updates the user's parameters" do 
        post :update, id: user.slug, user: { description: "Good guy" }
        expect(user.reload.description).to eq("Good guy")
      end

      it "sets the flash success" do 
        post :update, id: user.slug, user: { description: "Good guy" }
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to the users profile" do 
        post :update, id: user.slug, user: { description: "Good guy" }
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  # Too much of the logic is in the views right now

  describe "GET following" do 
    let(:user)      { Fabricate(:user) }
    let(:user2)     { Fabricate(:user) }
    let(:book)      { Fabricate(:book) }
    let(:user_book) { Fabricate(:user_book, user_id: user.id, book_id: book.id) }
    let(:user_book) { Fabricate(:user_book, user_id: user2.id, book_id: book.id) }

    before do 
      user.follow(user2)
      user2.follow(user)
    end

    # it "sets the @following variable by number of common books if logged in" 
    # it "sets the @following variable by number of followers if not logged in"
  end

  # Too much of the logic is in the views right now

  describe "GET followers"

end