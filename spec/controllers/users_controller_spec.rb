require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  describe "GET #new" do
    it "renders the sign up page" do
      get :new, user: {}

      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "when valid user" do
      it "redirects to user show page" do
        post :create, user: {username: "anthony", password: "password"}
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context "when invalid user" do
      it "validates presence of username and password" do
        post :create, user: {username: "name"}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe "GET #show" do
    it "renders the user show page" do
      User.create!(username: "name", password: "password")
      get :show, id: 1
    end
  end
end
