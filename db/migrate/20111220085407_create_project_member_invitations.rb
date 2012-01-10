class CreateProjectMemberInvitations < ActiveRecord::Migration
  def self.up
    create_table :project_member_invitations do |t|
      t.string :email
      t.integer :project_id
      t.integer :invited_by
      t.string :status
      t.string :initials
      t.string :name
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :project_member_invitations
  end
end
