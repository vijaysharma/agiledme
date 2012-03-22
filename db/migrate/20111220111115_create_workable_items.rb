class CreateWorkableItems < ActiveRecord::Migration
  def self.up
    create_table :workable_items do |t|
      t.string :title, :default => "As a <role>, I want <goal/desire> so that <benefit>"
      t.text :description
      t.integer :requester
      t.integer :owner
      t.integer :project_id
      t.integer :epic_id
      t.string :status
      t.integer :estimate
      t.string :type
      t.string :category, :default => 'icebox'
      t.integer :priority, :default => 0
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :delivered_at
      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end
  end

  def self.down
    drop_table :workable_items
  end
end
