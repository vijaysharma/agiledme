class Project < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => "project_users"
  has_many :project_users
  has_many :workable_items, :order=>"priority DESC", :dependent => :destroy
  has_many :epics, :dependent => :destroy
  has_many :workable_item_histories, :dependent => :destroy
  validates_presence_of :name

  def active_users
    users(true)
  end

  def inactive_users
    users(false)
  end

  private

  def users(status)
    self.project_users.where(:active => status).collect { |project_user| project_user.user }
  end
end
