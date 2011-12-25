class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => "users_projects"
  has_many :project_member_invitations, :dependent => :destroy
  has_many :workable_items, :dependent => :destroy
  has_many :epics, :dependent => :destroy
  validates_presence_of :name
end
