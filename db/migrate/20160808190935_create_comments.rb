class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.integer :author_id, null: false
      t.integer :goal_id, null: false
      t.timestamps null: false
    end
    add_index :comments, :author_id
    add_index :comments, :goal_id
  end
end
