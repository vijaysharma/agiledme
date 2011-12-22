class Task < ActiveRecord::Base
  belongs_to :workable_item

  include AASM

  validates_presence_of :description

  aasm_initial_state :new

  aasm :column => :status do
    state :new
    state :started, :enter => :update_started_by
    state :finished, :enter => :update_finished_by

    event :start do
      transitions :to => :started, :from => [:new]
    end

    event :finish do
      transitions :to => :finished, :from => [:started]
    end
  end

  private

  def update_started_by
    self.update_attribute(:started_by, User.current_user.id)
    self.save!
  end

  def update_finished_by
    self.update_attribute(:finished_by, User.current_user.id)
    self.save!
  end


end
