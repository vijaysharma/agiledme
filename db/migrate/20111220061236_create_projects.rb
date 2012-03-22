class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :sprint_length, :default => 2
      t.integer :velocity, :default => 10
      t.boolean :estimate_bugs, :default => false
      t.boolean :estimate_chores, :default => false
      t.datetime :start_date

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
