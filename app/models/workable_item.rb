class WorkableItem < ActiveRecord::Base

  include AASM

  belongs_to :project
  belongs_to :epic
  has_many :workable_item_histories, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  validates_presence_of :title
  validates_presence_of :category

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

  def is_estimatable?
    true;
  end

  private

  def update_started_by
    add_history("started")
    set_owner_as_current_user
    update_category("current")
  end

  def update_created_by
    add_history("created")
  end

  def update_finished_by
    add_history("finished")
    set_owner_as_current_user
  end

  def update_delivered_by
    add_history("delivered")
    set_owner_as_current_user
  end

  def update_accepted_by
    add_history("accepted")
    update_category("done")
  end

  def update_rejected_by
    add_history("rejected")
  end

  def update_restarted_by
    add_history("restarted")
    set_owner_as_current_user
  end

  def add_history(event)
    WorkableItemHistory.new(:event => event, :user_id => User.current_user.id, :workable_item_id => self.id).save!
  end

  def set_owner_as_current_user
    self.owner = User.current_user.id
    self.save!
  end

  def update_category(category)
    self.category = category
    self.save!
  end

end
