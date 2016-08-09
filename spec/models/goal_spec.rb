require 'rails_helper'

RSpec.describe Goal, :type => :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:completed) }
  it { should validate_presence_of(:private) }

  it { should belong_to(:user)}
  it { should have_many(:comments)}

  describe "complete_goal" do
    it "marks goal complete" do
      goal = FactoryGirl.build(:goal)
      goal.complete_goal
      expect(goal.completed).to be_truthy
    end
  end

  describe "make_private" do
    it "makes goal private" do
      goal = FactoryGirl.build(:goal)
      goal.make_private
      expect(goal.private).to be_truthy
    end
  end




end
