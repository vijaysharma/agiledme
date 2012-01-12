class CreateProjectUsers < ActiveRecord::Migration
  def self.up
    create_table :project_users, :id => false do |t|
      t.integer :user_id
      t.integer :project_id
      t.boolean :active
      t.string :role
    end
  end

  def self.down
    drop_table :project_users
  end
end
