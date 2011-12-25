class CreateWorkableItems < ActiveRecord::Migration
  def self.up
    create_table :workable_items do |t|
      t.string :title
      t.string :description
      t.integer :requester
      t.integer :owner
      t.integer :project_id
      t.integer :epic_id
      t.string :status
      t.integer :estimate
      t.string :type
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :workable_items
  end
end
