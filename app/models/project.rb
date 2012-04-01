class Project < ActiveRecord::Base
  has_many :users, :through => :project_users
  has_many :project_users, :dependent => :destroy
  has_many :stories, :order=>"priority DESC", :dependent => :destroy, :include => [ :comments, :tasks, :labels, :story_attachments ]
  has_many :epics, :dependent => :destroy
  has_many :story_histories, :dependent => :destroy
  validates_presence_of :name

  def active_users
    my_users(true)
  end

  def inactive_users
    my_users(false)
  end

  def current_velocity
    self.velocity
  end

  def labels
    all_labels_ids = StoryLabel.select(:label_id).where("story_id in (?)", self.story_ids).map(&:label_id)
    Label.where("id in (?)", all_labels_ids)
  end

  def current_sprint_start_date
    Date.today - days_passed_in_current_sprint
  end

  def sprint_commitment
    stories = nil
    if !self.estimate_bugs? and !self.estimate_chores?
      stories = self.stories.where(" category = 'current'")
    elsif project.estimate_bugs?
      stories = self.stories.where(" category = 'current' and type != 'Chore'")
    elsif project.estimate_chores?
      stories = self.stories.where(" category = 'current' and type != 'Bug'")
    end
    if stories.present?
      stories.sum("estimate")
    else
      0
    end
  end

  def current_sprint_end_date
    current_sprint_start_date + days_in_sprint
  end

  def days_in_sprint
    self.sprint_length * 7
  end

  private

  def days_passed_in_current_sprint
    (Date.today - self.start_date.to_date).to_i % days_in_sprint
  end

  def my_users(status)
    self.project_users.where(:active => status).collect { |project_user| project_user.user }
  end
end
