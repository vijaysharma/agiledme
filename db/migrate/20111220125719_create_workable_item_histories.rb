class CreateWorkableItemHistories < ActiveRecord::Migration
  def self.up
    create_table :workable_item_histories do |t|
      t.string :event
      t.integer :user_id
      t.integer :workable_item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workable_item_histories
  end
end
