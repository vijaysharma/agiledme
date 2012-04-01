class RenameColumnWorkableItemIdToStoryId < ActiveRecord::Migration
  def up
    rename_column :story_histories, :workable_item_id, :story_id
    rename_column :story_labels, :workable_item_id, :story_id
    rename_column :story_attachments, :workable_item_id, :story_id
    rename_column :tasks, :workable_item_id, :story_id
    rename_column :comments, :workable_item_id, :story_id
  end

  def down
  end
end
