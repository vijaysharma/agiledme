class RenameColumnWorkableItemIdToStoryId < ActiveRecord::Migration
  def up
    rename_column :story_histories, :workable_item_id, :story_id
    rename_column :story_labels, :workable_item_id, :story_id
    rename_column :story_attachments, :workable_item_id, :story_id
    rename_column :tasks, :workable_item_id, :story_id
    rename_column :comments, :workable_item_id, :story_id
  end

  def down
    rename_column :story_histories, :story_id, :workable_item_id
    rename_column :story_labels, :story_id, :workable_item_id
    rename_column :story_attachments, :story_id, :workable_item_id
    rename_column :tasks, :story_id, :workable_item_id
    rename_column :comments, :story_id, :workable_item_id
  end
end
