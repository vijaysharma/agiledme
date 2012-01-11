class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => "project_users"
  has_many :project_users
  has_many :workable_items, :order=>"priority DESC", :dependent => :destroy
  has_many :epics, :dependent => :destroy
  has_many :workable_item_histories, :dependent => :destroy
  validates_presence_of :name
end
