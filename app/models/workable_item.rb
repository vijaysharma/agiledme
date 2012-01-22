class WorkableItem < ActiveRecord::Base

  MINIMUM_POSSIBLE_PRIORITY = 0
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

  after_create :set_initial_default_values

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

  def self.next_priority_for(category)
    WorkableItem.maximum('priority', :group => 'category')[category] + 1
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
    is_estimatable? and (self.estimate.blank? or self.estimate < MINIMUM_POSSIBLE_PRIORITY)
  end

  def is_estimatable?
    true
  end

  def add_history(event)
    WorkableItemHistory.new(:event => event,
                            :user_id => User.current_user.id,
                            :workable_item_id => self.id,
                            :project_id => self.project.id).save!
  end

  def prioritize_above(other_item_id)
    other_item = WorkableItem.find(other_item_id)
    other_priority = other_item.priority
    other_category = other_item.category
    if re_prioritized_in_same_category?(other_category)
      if has_priority_increased?(other_priority)
        decrement_priorities_of_all_items_between_this_and_other_item(other_priority)
      elsif has_priority_decreased?(other_priority)
        increment_priorities_of_all_items_between_this_and_other_item(other_priority)
      end
      self.update_attributes!(:priority => other_priority)
    else
      other_item.increment_priorities_of_all_items_of_higher_priority
      self.update_attributes!(:priority => (other_priority + 1), :category => other_category)
    end
  end

  def update_status_change_history
    if changed_attributes["status"].present?
      if self.not_yet_started?
        add_history("un started this "+ self.type.downcase)
      elsif self.started?
        update_started_by
      elsif self.finished?
        update_finished_by
      elsif self.delivered?
        update_delivered_by
      elsif self.accepted?
        update_accepted_by
      elsif self.rejected?
        update_rejected_by
      else
        add_history(self.status" this "+ self.type.downcase)
      end
    end
  end


  private

  def increment_priorities_of_all_items_of_higher_priority
    all_items_of_higher_priority = self.project.workable_items.where("priority > ? and category = ?", self.priority, self.category)
    all_items_of_higher_priority.each do |item|
      item.update_attributes!(:priority => (item.priority + 1))
    end
  end

  def re_prioritized_in_same_category?(category)
    self.category.eql? category
  end

  def has_priority_increased?(other_priority)
    self.priority < other_priority
  end

  def has_priority_decreased?(other_priority)
    self.priority > other_priority
  end

  def decrement_priorities_of_all_items_between_this_and_other_item(other_priority)
    items_between_this_and_other = self.project.workable_items.where("priority > ? AND priority <= ? and category = ?", self.priority, other_priority, self.category)
    items_between_this_and_other.each do |item|
      item.update_attributes!(:priority => (item.priority - 1))
    end
  end

  def increment_priorities_of_all_items_between_this_and_other_item(other_priority)
    items_between_this_and_other = self.project.workable_items.where("priority < ? AND priority >= ? and category = ?", self.priority, other_priority, self.category)
    items_between_this_and_other.each do |item|
      item.update_attributes!(:priority => (item.priority + 1))
    end
  end

  def increment_priorities_of_all_items_in_current
    WorkableItem.where(:category => 'current').each do |item|
      item.update_attributes!(:priority => (item.priority + 1))
    end
  end

  def set_initial_default_values
    self.category = 'icebox'
    self.priority = WorkableItem.next_priority_for("icebox")
    self.save
    add_history("created this "+ self.type.downcase)
  end

  def update_started_by
    add_history("started this "+ self.type.downcase)
    self.started_at = Time.now
    move_item_to_current_category unless self.category.eql? "current"
  end

  def move_item_to_current_category
    self.category = "current"
    priority_to_set = WorkableItem.where(:category => 'current').minimum(:priority)
    if priority_to_set.present?
      increment_priorities_of_all_items_in_current
      self.priority = priority_to_set
    else
      self.priority = MINIMUM_POSSIBLE_PRIORITY
    end
  end

  def update_finished_by
    add_history("finished this "+ self.type.downcase)
    self.finished_at = Time.now
    set_owner_as_current_user
  end

  def update_delivered_by
    add_history("delivered this "+ self.type.downcase)
    self.delivered_at = Time.now
    set_owner_as_current_user
  end

  def update_accepted_by
    add_history("accepted this "+ self.type.downcase)
    self.accepted_at = Time.now
    self.save!
  end

  def update_rejected_by
    add_history("rejected this "+ self.type.downcase)
    self.rejected_at = Time.now
    self.save!
  end

  def update_restarted_by
    add_history("restarted this "+ self.type.downcase)
    set_owner_as_current_user
  end

  def set_owner_as_current_user
    self.owner = User.current_user.id
    self.save!
  end

end
