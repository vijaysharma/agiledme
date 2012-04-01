class RenameWorkableItemsToStories < ActiveRecord::Migration
  def up
    rename_table :workable_items, :stories
    rename_table :workable_item_attachments, :story_attachments
    rename_table :workable_item_labels, :story_labels
    rename_table :workable_item_histories, :story_histories
  end

  def down
    rename_table :stories, :workable_items
    rename_table :story_attachments, :workable_item_attachments
    rename_table :story_labels, :workable_item_labels
    rename_table :story_histories, :workable_item_histories
  end
end
