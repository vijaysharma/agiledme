class CreateEpics < ActiveRecord::Migration
  def self.up
    create_table :epics do |t|
      t.string :title
      t.string :description
      t.integer :project_id
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :epics
  end
end
