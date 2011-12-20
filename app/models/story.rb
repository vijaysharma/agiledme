class Story < ActiveRecord::Base

  include AASM

  belongs_to :project
  has_many :story_histories
  validates_presence_of :title

  after_create :update_created_by

  aasm_initial_state :new

  aasm :column => :status do
    state :new
    state :started, :enter => :update_started_by
    state :finished, :enter => :update_finished_at
    state :delivered, :enter => :update_delivered_at
    state :accepted, :enter => :update_accepted_at
    state :rejected, :enter => :update_rejected_at

    event :start do
      transitions :to => :started, :from => [:new]
    end

    event :finish do
      transitions :to => :finished, :from => [:started]
    end

    event :deliver do
      transitions :to => :delivered, :from => [:finished]
    end

    event :accept do
      transitions :to => :accepted, :from => [:delivered]
    end

    event :reject do
      transitions :to => :rejected, :from => [:delivered]
    end

    event :restart do
      transitions :to => :started, :from => [:rejected]
    end
  end


  def update_started_by
    StoryHistory.new(:event => "started", :user_id => current_user.id, :story_id => self.id).save!
  end

  def update_created_by
    StoryHistory.new(:event => "created", :user_id => User.current_user.id, :story_id => self.id).save!
  end

end
