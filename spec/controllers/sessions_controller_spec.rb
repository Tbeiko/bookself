require 'spec_helper'

describe SessionsController do 
  describe "GET new" do 
    it "renders the new template for admin users" do 
      user = Fabricate(:user, email: "t.beiko@live.ca")
      session[:user_id] = user.id
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the homepage for non-admin users" do 
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do 
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end
    it "should create a user" do 
      expect {
        post :create, provider: :facebook, auth: OmniAuth.config.mock_auth[:facebook]
      }.to change{ User.count }.by(1)
    end
  end

  describe "GET destroy" do 
    before do 
      session[:user_id] = Fabricate(:user).id 
      get :destroy
    end
    it "clears the session for the user" do 
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do 
      expect(response).to redirect_to root_path
    end
  end
end