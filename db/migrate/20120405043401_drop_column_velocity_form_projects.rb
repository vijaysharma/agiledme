class DropColumnVelocityFormProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :velocity
  end

  def down
    add_column :projects, :velocity, :integer
  end
end