class AddGoalColumns < ActiveRecord::Migration
  def change
    add_column( :goals, :private , :boolean, default: false )
    add_column( :goals, :completed, :boolean, default: false )
  end
end
