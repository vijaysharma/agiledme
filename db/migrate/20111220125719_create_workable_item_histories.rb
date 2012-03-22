class CreateWorkableItemHistories < ActiveRecord::Migration
  def self.up
    create_table :workable_item_histories do |t|
      t.text :event
      t.integer :user_id
      t.integer :workable_item_id
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workable_item_histories
  end
end
