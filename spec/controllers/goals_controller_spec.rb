require 'rails_helper'

RSpec.describe GoalsController, :type => :controller do

  describe "GET #new" do
    it "renders the new page when logged in" do
      user = double('user')
      allow(controller).to receive(:current_user).and_return(user)
      get :new, goal: {}
      expect(response).to have_http_status(200)
      expect(response).to render_template("new")
    end

    it "redirects to sign-in page when not logged in" do
      get :new, goal: {}
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "POST #create" do
    it "creates a new goal when goal is valid" do
      user = instance_double('User', id: 3)
      allow(controller).to receive(:current_user).and_return(user)
      post :create, goal: { name: Faker::Hacker.say_something_smart }
      expect(response).to redirect_to(goal_url(Goal.last))
      expect(response).to have_http_status(302)
    end

    it "re-renders new when goal is invalid" do
      user = instance_double('User', id: 3)
      allow(controller).to receive(:current_user).and_return(user)
      post :create, goal: {name: nil}
      expect(response).to render_template("new")
      expect(flash[:errors]).to be_present
    end
  end

  describe "GET #edit" do
    it "renders edit page when logged in" do
      user = instance_double('User', id: 3)
      allow(controller).to receive(:current_user).and_return(user)
      # user = User.create(username: Faker::Name.name, password: "password")
      goal = FactoryGirl.create(:goal, user_id: user.id)
      get :edit, id: Goal.last.id

      expect(response).to render_template("edit")
      expect(response).to have_http_status(200)
    end

    it "redirects to sign-in page when not logged in" do
      user = User.create(username: Faker::Name.name, password: "password")
      goal = FactoryGirl.create(:goal, user_id: user.id)
      get :edit, id: Goal.last.id
      expect(response).to redirect_to(new_session_url)
    end
  end

  describe "POST #update" do
    it "updates a user's own goal when valid" do
      user = instance_double('User', id: 1)
      allow(controller).to receive(:current_user).and_return(user)
      goal = FactoryGirl.create(:goal, user_id: user.id)
      patch :update, id: Goal.last.id, goal: {name: "New goal name", private: true, completed: true}

      expect(Goal.last.name).to eq("New goal name")
      expect(Goal.last.private).to eq(true)
      expect(Goal.last.completed).to eq(true)
      expect(response).to redirect_to(goal_url(Goal.last))
    end
  end

  describe "GET #show" do
    it "won't show goals if not logged in" do
      user = instance_double('User', id: 1)
      goal = FactoryGirl.create(:goal, user_id: user.id)
      get :show, id: Goal.last.id

      expect(response).to redirect_to(new_session_url)
    end

    it "displays goal show page if logged in" do
      user = instance_double('User', id: 1)
      allow(controller).to receive(:current_user).and_return(user)
      goal = FactoryGirl.create(:goal, user_id: user.id)

      get :show, id: Goal.last.id

      expect(response).to render_template("show")
    end

    it "does not show page if private and not logged in as user" do
      user1 = instance_double('User', id: 1)
      allow(controller).to receive(:current_user).and_return(user1)
      user2 = instance_double('User', id: 2)
      goal = FactoryGirl.create(:private_goal, user_id: user2.id)

      post :show, id: Goal.last.id

      expect(response).to redirect_to(user_url(user2.id))
    end
  end
end
