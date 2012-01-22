class CreateWorkableItemAttachments < ActiveRecord::Migration
  def self.up
    create_table :workable_item_attachments do |t|
      t.integer :workable_item_id
      t.has_attached_file :image
      t.timestamps
    end
  end

  def self.down
    drop_table :workable_item_attachments
    drop_attached_file :users, :avatar
  end
end
