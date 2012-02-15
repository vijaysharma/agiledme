class CreateWorkableItemAttachments < ActiveRecord::Migration
  def self.up
    create_table :workable_item_attachments do |t|
      t.integer :workable_item_id
      t.string :image
      t.string :content_type
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :workable_item_attachments
  end
end
