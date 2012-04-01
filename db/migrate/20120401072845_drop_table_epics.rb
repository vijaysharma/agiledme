class DropTableEpics < ActiveRecord::Migration
  def up
    drop_table :epics
  end

  def down
    create_table :epics do |t|
      t.string :title
      t.text :description
      t.integer :project_id
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
