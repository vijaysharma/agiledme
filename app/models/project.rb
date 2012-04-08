class Project < ActiveRecord::Base
  has_many :users, :through => :project_users
  has_many :project_users, :dependent => :destroy
  has_many :stories, :order=>"priority DESC", :dependent => :destroy
  has_many :epics, :dependent => :destroy
  has_many :story_histories, :dependent => :destroy
  validates_presence_of :name

  def active_users
    my_users(true)
  end

  def velocity_trend
    velocity_trend_between_sprints(1, no_of_sprints_passed)
  end

  def inactive_users
    my_users(false)
  end

  def velocity
    velocity_trend_between_sprints(no_of_sprints_passed , no_of_sprints_passed).first
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
      stories = self.stories.where(" category = 'current' and type = 'Feature'")
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
    current_sprint_start_date + sprint_length_in_days
  end

  def sprint_length_in_days
    sprint_length * 7
  end

  private

  def days_passed_in_current_sprint
    no_of_days_in_project % sprint_length_in_days
  end

  def no_of_sprints_passed
    no_of_days_in_project / sprint_length_in_days
  end

  def no_of_days_in_project
    (Date.today - start_date.to_date).to_i
  end

  def my_users(status)
    self.project_users.where(:active => status).collect { |project_user| project_user.user }
  end

  def velocity_trend_between_sprints(from_sprint, to_sprint)
    beginning_of_from_sprint = (start_date.to_date + ((from_sprint - 1) * sprint_length_in_days).days).beginning_of_day
    end_of_to_sprint = (beginning_of_from_sprint + (to_sprint * sprint_length_in_days).days).end_of_day

    stories_between_sprints = nil

    if !estimate_bugs? and !estimate_chores?
      stories_between_sprints = stories.where(" status in ('delivered', 'accepted') and type = 'Feature'").where(:delivered_at => beginning_of_from_sprint..end_of_to_sprint)
    elsif project.estimate_bugs?
      stories_between_sprints = stories.where(" status in ('delivered', 'accepted') and type != 'Chore'").where(:delivered_at => beginning_of_from_sprint..end_of_to_sprint)
    elsif project.estimate_chores?
      stories_between_sprints = stories.where(" status in ('delivered', 'accepted') and type != 'Bug'").where(:delivered_at => beginning_of_from_sprint..end_of_to_sprint)
    end

    velocities = []
    if stories_between_sprints.present?
      (from_sprint..to_sprint.to_i).each do |sprint|
        beginning_of_sprint = (start_date.to_date + ((sprint - 1) * sprint_length_in_days).days).beginning_of_day
        end_of_sprint = (beginning_of_sprint + sprint_length_in_days.days).end_of_day
        sprint_stories = stories_between_sprints.select {|story| story.delivered_at >= beginning_of_sprint and story.delivered_at <= end_of_sprint}


        if sprint_stories.present?
          velocities << sprint_stories.sum(&:estimate)
        else
          velocities << 0
        end
      end
    else
      (from_sprint..to_sprint.to_i).each do
        velocities << 0
      end
    end
    velocities
  end

end
