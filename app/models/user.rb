class User < ActiveRecord::Base
  ROLES = %w[owner member viewer]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :initials, :role
  cattr_accessor :current_user

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create
  has_and_belongs_to_many :projects, :join_table => "project_users"
  has_many :project_users
  has_many :workable_item_histories

  def all_workable_item_histories_for_all_my_projects
    WorkableItemHistory.all(:conditions => ["project_id in (?)", self.project_ids],
                            :order => "created_at DESC",
                            :limit => 10)
  end

end
