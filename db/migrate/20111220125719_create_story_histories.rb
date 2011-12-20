class CreateStoryHistories < ActiveRecord::Migration
  def self.up
    create_table :story_histories do |t|
      t.string :event
      t.integer :user_id
      t.integer :story_id

      t.timestamps
    end
  end

  def self.down
    drop_table :story_histories
  end
end
