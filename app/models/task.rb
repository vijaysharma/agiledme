class Task < ActiveRecord::Base
  belongs_to :workable_item

  include AASM

  validates_presence_of :description

  aasm_initial_state :new

  aasm :column => :status do
    state :new
    state :finished, :enter => :update_finished_by

    event :finish do
      transitions :to => :finished, :from => [:new]
    end
  end

  private

  def update_finished_by
    self.update_attribute(:finished_by, User.current_user.id)
    self.save!
  end


end
