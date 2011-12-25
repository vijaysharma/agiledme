class Epic < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :workable_items

  include AASM

  validates_presence_of :title

  aasm_initial_state :new

  aasm :column => :status do
    state :new
    state :in_progress
    state :finished

    event :start_splitting do
      transitions :to => :split_in_progress, :from => [:new]
    end

    event :finish do
      transitions :to => :finished, :from => [:in_progress]
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
