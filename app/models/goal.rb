class Goal < ActiveRecord::Base
  validates :name, :user_id, presence: true

  belongs_to :user
  has_many :comments

  def complete_goal
    self.completed = true
  end

  def make_private
    self.private = true
  end
end
