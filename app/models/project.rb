class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => "users_projects"
  has_many :pending_invitations
end
