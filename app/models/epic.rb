class Epic < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :stories

  include AASM

  validates_presence_of :title

  aasm_initial_state :new

  aasm :column => :status do
    state :new
    state :split_in_progress
    state :finished

    event :start_splitting do
      transitions :to => :split_in_progress, :from => [:new]
    end

    event :finish do
      transitions :to => :finished, :from => [:split_in_progress]
    end
  end
end
