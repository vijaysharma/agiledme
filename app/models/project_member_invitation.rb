class ProjectMemberInvitation < ActiveRecord::Base
  belongs_to :project
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create

  include AASM

  aasm_initial_state :pending

  aasm :column => :status do
    state :pending
    state :confirmed

    event :confirm do
      transitions :to => :confirmed, :from => [:pending]
    end
  end

end
