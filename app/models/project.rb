class Project < ActiveRecord::Base
  has_many :users, :through => :project_users
  has_many :project_users, :dependent => :destroy
  has_many :workable_items, :order=>"priority DESC", :dependent => :destroy
  has_many :epics, :dependent => :destroy
  has_many :workable_item_histories, :dependent => :destroy
  validates_presence_of :name

  def active_users
    my_users(true)
  end

  def inactive_users
    my_users(false)
  end

  def points_burned_down_on(date)
    if !self.estimate_bugs? and !self.estimate_chores?
      self.workable_items.where(" status = 'delivered' and date(delivered_at) = ?", date).sum(:estimate)
    elsif self.estimate_bugs?
      self.workable_items.where(" status = 'delivered' and type != 'Chore' and date(delivered_at) = ? ", date).sum(:estimate)
    elsif self.estimate_chores?
      self.workable_items.where(" status = 'delivered' and type != 'Bug' and date(delivered_at) = ? ", date).sum(:estimate)
    end
  end

  private

  def my_users(status)
    self.project_users.where(:active => status).collect { |project_user| project_user.user }
  end
end
