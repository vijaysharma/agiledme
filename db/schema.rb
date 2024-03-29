# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120405043401) do

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "story_id"
    t.integer  "posted_by"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["posted_by"], :name => "index_comments_on_posted_by"
  add_index "comments", ["story_id"], :name => "index_comments_on_workable_item_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "labels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "labels", ["name"], :name => "index_labels_on_name"

  create_table "project_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "active"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_users", ["project_id"], :name => "index_project_users_on_project_id"
  add_index "project_users", ["user_id"], :name => "index_project_users_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sprint_length",   :default => 2
    t.boolean  "estimate_bugs",   :default => false
    t.boolean  "estimate_chores", :default => false
    t.datetime "start_date"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "stories", :force => true do |t|
    t.text     "title",        :default => "As a <role>, I want <goal/desire> so that <benefit>"
    t.text     "description"
    t.integer  "requester"
    t.integer  "owner"
    t.integer  "project_id"
    t.integer  "epic_id"
    t.string   "status"
    t.integer  "estimate"
    t.string   "type"
    t.string   "category",     :default => "icebox"
    t.integer  "priority",     :default => 0
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "delivered_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
  end

  add_index "stories", ["category"], :name => "index_workable_items_on_category"
  add_index "stories", ["project_id"], :name => "index_workable_items_on_project_id"

  create_table "story_attachments", :force => true do |t|
    t.integer  "story_id"
    t.string   "image"
    t.string   "content_type"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "story_attachments", ["story_id"], :name => "index_workable_item_attachments_on_workable_item_id"
  add_index "story_attachments", ["user_id"], :name => "index_workable_item_attachments_on_user_id"

  create_table "story_histories", :force => true do |t|
    t.text     "event"
    t.integer  "user_id"
    t.integer  "story_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "story_histories", ["project_id"], :name => "index_workable_item_histories_on_project_id"
  add_index "story_histories", ["story_id"], :name => "index_workable_item_histories_on_workable_item_id"
  add_index "story_histories", ["user_id"], :name => "index_workable_item_histories_on_user_id"

  create_table "story_labels", :force => true do |t|
    t.integer  "story_id"
    t.integer  "label_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "story_labels", ["label_id"], :name => "index_workable_item_labels_on_label_id"
  add_index "story_labels", ["story_id"], :name => "index_workable_item_labels_on_workable_item_id"

  create_table "tasks", :force => true do |t|
    t.text     "description"
    t.integer  "story_id"
    t.integer  "created_by"
    t.integer  "finished_by"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tasks", ["created_by"], :name => "index_tasks_on_created_by"
  add_index "tasks", ["finished_by"], :name => "index_tasks_on_finished_by"
  add_index "tasks", ["story_id"], :name => "index_tasks_on_workable_item_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "initials"
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
