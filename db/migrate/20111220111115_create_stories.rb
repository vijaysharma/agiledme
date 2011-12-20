class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string :title
      t.string :description
      t.integer :requester
      t.integer :owner
      t.integer :project_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
