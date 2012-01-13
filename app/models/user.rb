class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :initials
  cattr_accessor :current_user

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create
  validates_uniqueness_of :email
  has_and_belongs_to_many :projects, :join_table => "project_users"
  has_many :project_users
  has_many :workable_item_histories

  def all_workable_item_histories_for_all_my_projects
    WorkableItemHistory.all(:conditions => ["project_id in (?)", self.project_ids],
                            :order => "created_at DESC",
                            :limit => 10)
  end

  def invited_by
    User.find(self.invited_by_id)
  end

  def join_project
  end

end
