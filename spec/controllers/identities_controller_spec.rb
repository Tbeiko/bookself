require 'spec_helper'

describe IdentitiesController do 
  context "as admin user" do 
    describe "GET new" do 
      # Not sure how to test this, because it is linked with the sessions controller
    end

    describe "POST create" do 
      context "with valid input" do 
        let(:identity) { Fabricate(:identity) }
        it "creates a new identity instance" do 
          post :create, identity: identity
          expect(Identity.count).to eq(1)
        end
      end

      context "with invalid input" do 
        it "does not create a new identity instance" do 
          post :create, identity: { id: 1, password: "1234" }
          expect(Identity.count).to eq(0)
        end

        it "redirects to root_path" do 
          post :create, identity: { id: 1, password: "1234" }
          expect(response).to redirect_to root_path
        end
      end
    end
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