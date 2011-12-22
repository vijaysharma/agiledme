class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :description
      t.integer :workable_item_id
      t.integer :created_by
      t.integer :started_by
      t.integer :finished_by
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
