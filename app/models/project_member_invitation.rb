class ProjectMemberInvitation < ActiveRecord::Base
  belongs_to :project
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create
  validates_uniqueness_of :email

  attr_accessor :invitee_details
  attr_accessible :invitee_details, :role, :invited_by, :project_id

  include AASM

  aasm_initial_state :pending

  aasm :column => :status do
    state :pending
    state :confirmed

    event :confirm do
      transitions :to => :confirmed, :from => [:pending]
    end
  end

  def self.roles
    %w[Owner Member Viewer]
  end

  def add_new_invitee!

    name = ""
    email = ""
    initials = ""
    invitee_details_value = self.invitee_details
    if (invitee_details_value.include?('<'))
      name = invitee_details_value.split('<')[0].split('(')[0]
      initials = invitee_details_value.split('<')[0].split('(')[1].split(')')[0]
      email = invitee_details_value.split('<')[1].split('>')[0]
    elsif invitee_details_value.include?(',')
      name = invitee_details_value.split(',')[0].strip
      email = invitee_details_value.split(',')[1]
    end
    self.initials = initials.strip
    self.name = name.strip
    self.email = email.strip
    self.save
  end
end
