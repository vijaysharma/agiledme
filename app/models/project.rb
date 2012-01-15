class Project < ActiveRecord::Base
  has_many :users, :through => :project_users
  has_many :project_users
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

  private

  def my_users(status)
    self.project_users.where(:active => status).collect { |project_user| project_user.user }
  end
end
