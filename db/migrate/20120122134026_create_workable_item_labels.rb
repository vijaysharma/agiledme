class CreateWorkableItemLabels < ActiveRecord::Migration
  def self.up
    create_table :workable_item_labels do |t|
      t.integer :workable_item_id
      t.integer :label_id

      t.timestamps
    end
  end

  def self.down
    drop_table :workable_item_labels
  end
end
