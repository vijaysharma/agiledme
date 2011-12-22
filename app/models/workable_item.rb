class WorkableItem < ActiveRecord::Base

  include AASM

  belongs_to :project
  has_many :workable_item_histories, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  validates_presence_of :title
  validates_numericality_of :estimate

  after_create :update_created_by

  aasm_initial_state :new

  aasm :column => :status do
    state :new
    state :started, :enter => :update_started_by
    state :finished, :enter => :update_finished_by
    state :delivered, :enter => :update_delivered_by
    state :accepted, :enter => :update_accepted_by
    state :rejected, :enter => :update_rejected_by

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

  private

  def update_started_by
    update_history("started")
    self.owner = User.current_user.id
    self.save!
  end

  def update_created_by
    update_history("created")
  end

  def update_finished_by
    update_history("finished")
  end

  def update_delivered_by
    update_history("delivered")
  end

  def update_accepted_by
    update_history("accepted")
  end

  def update_rejected_by
    update_history("rejected")
  end

  def update_restarted_by
    update_history("restarted")
    self.owner = User.current_user.id
    self.save!
  end

  def update_history(event)
    WorkableItemHistory.new(:event => event, :user_id => User.current_user.id, :workable_item_id => self.id).save!
  end

end
