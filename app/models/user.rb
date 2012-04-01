class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :initials
  cattr_accessor :current_user

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create
  has_many :projects, :through => :project_users
  has_many :project_users, :dependent => :destroy
  has_many :story_histories

  def all_story_histories_for_all_my_projects
    StoryHistory.order("created_at DESC").where("project_id in (?)", self.project_ids)
  end

  def display_name
    self.name || self.email
  end

  def initials_display_name
    self.initials || display_name
  end

  def invited_by
    User.find(self.invited_by_id) unless self.invited_by_id.blank?
  end

  def not_accepted_the_invitation?
    self.invited_by.present? and self.invitation_token.present?
  end

  def is_owner?(project)
    project.project_users.where(:role => 'owner').map(&:user_id).include? self.id
  end


  def can_manage_members_of(project)
    project_user = self.project_users.find_by_project_id(project.id)
    project_user and (project_user.role == 'owner' or project_user.role == 'member')
  end

  def belongs_to_project?(project)
    self.project_users.find_by_project_id(project.id).active?
  end

  def join_project(project)
    project_user = self.project_users.find_by_project_id(project.id)
    project_user.update_attributes!(:active => true)
  end

  def leave_project(project)
    project_user = self.project_users.find_by_project_id(project.id)
    project_user.update_attributes!(:active => false)
  end

end
