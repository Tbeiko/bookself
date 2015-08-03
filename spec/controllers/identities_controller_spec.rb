require 'spec_helper'

describe IdentitiesController do 
  context "as admin user" do 
    # Not sure how to test this
  end

  context "as non-admin user" do 
    let(:user) { Fabricate(:user) }
    before do 
      session[:id] = user.id
    end

    describe "GET new" do 
      it "redirects if the user is not an admin" do 
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe "POST create" do 
      it "redirects if the user is not an admin" do 
        post :create
        expect(response).to redirect_to root_path
      end
    end
  end
end