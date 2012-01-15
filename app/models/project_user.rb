class ProjectUser < ActiveRecord::Base
  ROLES = %w[owner member viewer]
  belongs_to :project
  belongs_to :user

  attr_accessor :invitee_details

end