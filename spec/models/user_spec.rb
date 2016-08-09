require 'rails_helper'

RSpec.describe User, :type => :model do

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }

  User.create(username: "different_name2", password: "password2")

  it { should validate_uniqueness_of(:username) }

  it { should have_many(:goals) }
  it { should have_many(:comments) }

  describe "find_by_credentials" do
    before(:each) {User.create(username: "name", password: "password")}
    it "should return a user when valid user" do
      expect(User.find_by_credentials("name", "password")).to eq(User.last)
    end

    it "should return nil when no valid user" do
      # User.create!(username: "name", password: "password")
      expect(User.find_by_credentials("name", "passsword")).to eq(nil)
    end

    it "should return nil when no username given" do
      # User.create!(username: "name", password: "password")
      expect(User.find_by_credentials("", "password")).to eq(nil)
    end

  end

  describe "reset_session_token!" do
    it "should reset the session token" do
      User.create(username: "name", password: "password")
      old_token = User.first.session_token
      User.first.reset_session_token!
      expect(User.first.session_token).to_not be(old_token)
    end

  end

  describe "password=" do
    it "shouldn't save the password" do
      User.create(username: "name", password: "password")
      expect(User.first.password_digest).to_not equal("password")
      expect(User.first.password_digest).to_not be(nil)
    end
  end


end
