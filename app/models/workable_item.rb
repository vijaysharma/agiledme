class WorkableItem < ActiveRecord::Base

  include AASM

  belongs_to :project
  belongs_to :epic
  has_many :workable_item_histories, :dependent => :destroy
  has_many :tasks, :order=>"updated_at DESC", :dependent => :destroy
  has_many :comments, :order=>"updated_at DESC", :dependent => :destroy

  accepts_nested_attributes_for :tasks, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :comments, :allow_destroy => true, :reject_if => :all_blank


  validates_presence_of :title
  validates_presence_of :category

  after_create :update_created_by
  before_update :add_status_history

  aasm_initial_state :not_yet_started

  aasm :column => :status do
    state :not_yet_started
    state :started, :enter => :update_started_by
    state :finished, :enter => :update_finished_by
    state :delivered, :enter => :update_delivered_by
    state :accepted, :enter => :update_accepted_by
    state :rejected, :enter => :update_rejected_by

    event :start do
      transitions :to => :started, :from => [:not_yet_started]
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

  def self.types
    %w[Story Bug Chore]
  end

  def self.fibonacci_estimates
    %w[0 1 2 3 5 8]
  end

  def self.categories
    %w[done current backlog icebox]
  end

  def self.estimates
    {"Unestimated" => -1, "0 Points" => 0, "1 Points" => 1, "2 Points" => 2, "3 Points" => 3, "5 Points" => 5, "8 Points" => 8}
  end

  def is_ready?
    !is_estimatable? or (is_estimatable? and self.estimate != -1)
  end

  def is_unestimated?
    is_estimatable? and self.estimate < 0
  end

  def is_estimatable?
    true
  end

  def add_status_history
    if changed_attributes["status"].present?
      action = (self.not_yet_started? ? "un started" : self.status)
      add_history(action + " this "+ self.type.downcase)
    end
  end

  def add_history(event)
    WorkableItemHistory.new(:event => event,
                            :user_id => User.current_user.id,
                            :workable_item_id => self.id,
                            :project_id => self.project.id).save!
  end


  private

  def update_started_by
    add_history("started this "+ self.type.downcase)
    set_owner_as_current_user
    update_category("current")
  end

  def update_created_by
    add_history("created this "+ self.type.downcase)
  end

  def update_finished_by
    add_history("finished this "+ self.type.downcase)
    set_owner_as_current_user
  end

  def update_delivered_by
    add_history("delivered this "+ self.type.downcase)
    set_owner_as_current_user
  end

  def update_accepted_by
    add_history("accepted this "+ self.type.downcase)
  end

  def update_rejected_by
    add_history("rejected this "+ self.type.downcase)
  end

  def update_restarted_by
    add_history("restarted this "+ self.type.downcase)
    set_owner_as_current_user
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
