class ProjectMemberInvitation < ActiveRecord::Base
  belongs_to :project
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create
  validates_uniqueness_of :email

  attr_accessor :invitee_details

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

  def add_new_invitee

  end

end
