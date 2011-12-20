class CreatePendingInvitations < ActiveRecord::Migration
  def self.up
    create_table :pending_invitations do |t|
      t.string :email
      t.integer :project_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pending_invitations
  end
end
