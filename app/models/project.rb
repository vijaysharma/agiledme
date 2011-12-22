class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => "users_projects"
  has_many :project_member_invitations
  has_many :workable_items
end
