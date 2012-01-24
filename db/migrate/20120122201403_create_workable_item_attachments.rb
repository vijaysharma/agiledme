class CreateWorkableItemAttachments < ActiveRecord::Migration
  def self.up
    create_table :workable_item_attachments do |t|
      t.integer :workable_item_id
      t.has_attached_file :image
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :workable_item_attachments
  end
end
