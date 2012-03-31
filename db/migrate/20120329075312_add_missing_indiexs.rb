class AddMissingIndiexs < ActiveRecord::Migration
  def up
    add_index :workable_items, :project_id
    add_index :workable_items, :category
    add_index :project_users, :user_id
    add_index :project_users, :project_id
    add_index :workable_item_histories, :project_id
    add_index :workable_item_histories, :user_id
    add_index :workable_item_histories, :workable_item_id
    add_index :tasks, :workable_item_id
    add_index :tasks, :finished_by
    add_index :tasks, :created_by
    add_index :comments, :workable_item_id
    add_index :comments, :posted_by
    add_index :epics, :project_id
    add_index :epics, :user_id
    add_index :labels, :name
    add_index :workable_item_labels, :workable_item_id
    add_index :workable_item_labels, :label_id
    add_index :workable_item_attachments, :workable_item_id
    add_index :workable_item_attachments, :user_id
  end

  def down
    remove_index :workable_items, :project_id
    remove_index :workable_items, :category
    remove_index :project_users, :user_id
    remove_index :project_users, :project_id
    remove_index :workable_item_histories, :project_id
    remove_index :workable_item_histories, :user_id
    remove_index :workable_item_histories, :workable_item_id
    remove_index :tasks, :workable_item_id
    remove_index :tasks, :finished_by
    remove_index :tasks, :created_by
    remove_index :comments, :workable_item_id
    remove_index :comments, :posted_by
    remove_index :epics, :project_id
    remove_index :epics, :user_id
    remove_index :labels, :name
    remove_index :workable_item_labels, :workable_item_id
    remove_index :workable_item_labels, :label_id
    remove_index :workable_item_attachments, :workable_item_id
    remove_index :workable_item_attachments, :user_id
  end
end
