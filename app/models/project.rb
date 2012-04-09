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

  def default_from_sprint
    no_of_sprints_passed >= 10 ? no_of_sprints_passed - 5 : 1
  end

  def velocity_trend
    velocity_trend_between_sprints(default_from_sprint, no_of_sprints_passed)
  end

  def chores_trend
    stories_trend_between_sprints(default_from_sprint, no_of_sprints_passed, 'Chore')
  end

  def bugs_trend
    stories_trend_between_sprints(default_from_sprint, no_of_sprints_passed, 'Bug')
  end

  def features_trend
    stories_trend_between_sprints(default_from_sprint, no_of_sprints_passed, 'Feature')
  end

  def inactive_users
    my_users(false)
  end

  def velocity
    velocity_trend_between_sprints(no_of_sprints_passed, no_of_sprints_passed).first
  end

  def labels
    labels_ids = StoryLabel.select(:label_id).where("story_id in (?)", self.story_ids).map(&:label_id)
    Label.where("id in (?)", labels_ids)
  end

  def current_sprint_end_date
    current_sprint_start_date + sprint_length_in_days
  end

  def current_sprint_start_date
    Date.today - days_passed_in_current_sprint
  end

  def sprint_length_in_days
    sprint_length * 7
  end

  def no_of_sprints_passed
    no_of_days_in_project / sprint_length_in_days
  end

  def truncated_name
    name.slice(0, 40)
  end

  def velocity_trend_between_sprints(from_sprint, to_sprint)
    stories_between_sprints = estimatable_stories.where(" status in ('delivered', 'accepted')").
        where(:delivered_at => beginning_of_sprint(from_sprint)..end_of_sprint(to_sprint))

    velocities = []

    if stories_between_sprints.present?
      (from_sprint..to_sprint.to_i).each do |sprint|
        # I have done select specifically to avoid the multiple queries.... think before removing it!!
        sprint_stories = stories_between_sprints.select { |story| story.delivered_at >= beginning_of_sprint(sprint) and story.delivered_at <= end_of_sprint(sprint) }

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

  def stories_trend_between_sprints(from_sprint, to_sprint, story_type)
    stories_between_sprints = stories.where(" status in ('delivered', 'accepted') and type = ? ", story_type).
        where(:delivered_at => beginning_of_sprint(from_sprint)..end_of_sprint(to_sprint))

    stories = []
    if stories_between_sprints.present?
      (from_sprint..to_sprint.to_i).each do |sprint|
        # I have done select specifically to avoid the multiple queries.... think before removing it!!
        sprint_stories = stories_between_sprints.select { |story| story.delivered_at >= beginning_of_sprint(sprint) and story.delivered_at <= end_of_sprint(sprint) }

        if sprint_stories.present?
          stories << sprint_stories.count
        else
          stories << 0
        end
      end
    else
      (from_sprint..to_sprint.to_i).each do
        stories << 0
      end
    end
    stories
  end

  def actual_burndown_data_series
    actual_burndown_data_series_for_sprint(current_sprint)
  end

  def actual_burndown_data_series_for_sprint(sprint)
    actual = []
    sprint_stories = estimatable_stories.where("status in ('delivered', 'accepted')")
    if sprint_stories.present?
      start_time = beginning_of_sprint(sprint)
      stories_by_day = sprint_stories.where(:delivered_at => start_time..Date.today.end_of_day).
          group("delivered_at, priority").
          select("delivered_at as date, sum(estimate) as estimate")

      stories_by_day.concat sprint_stories.where(:accepted_at => start_time..Date.today.end_of_day).
                                group("accepted_at, priority").
                                select("accepted_at as date, sum(estimate) as estimate")

      commitment = sprint_commitment(sprint)
      no_of_days = sprint == current_sprint ? days_passed_in_current_sprint : sprint_length_in_days
      actual = no_of_days.times.collect do |day|
        date = start_time + day.days
        story = stories_by_day.detect { |story| story.date.to_date == date }
        commitment = commitment - (story && story.estimate || 0)
      end
    end
    actual
  end

  def idle_burndown_data_series
    idle_burndown_data_series_for_sprint(current_sprint)
  end

  def idle_burndown_data_series_for_sprint(sprint)
    commitment = sprint_commitment(sprint)
    points_to_burn_per_day = commitment.to_f / sprint_length_in_days
    idle = sprint_length_in_days.times.collect do |day|
      commitment - (points_to_burn_per_day * day)
    end
    idle
  end

  def current_sprint
    days_passed_in_current_sprint > 0 ? no_of_sprints_passed + 1 : no_of_sprints_passed
  end

  def beginning_of_sprint(sprint)
    (start_date.to_date + ((sprint - 1) * sprint_length_in_days).days).beginning_of_day
  end

  private

  def sprint_commitment(sprint)
    start_time = beginning_of_sprint(sprint)
    end_time = end_of_sprint(sprint)
    stories = estimatable_stories.where(:accepted_at => start_time..end_time)
    if stories.present?
      stories.sum(&:estimate)
    else
      0
    end
  end

  def days_passed_in_current_sprint
    no_of_days_in_project % sprint_length_in_days
  end

  def no_of_days_in_project
    (Date.today - start_date.to_date).to_i
  end

  def my_users(status)
    self.project_users.where(:active => status).collect { |project_user| project_user.user }
  end

  def end_of_sprint(sprint)
    (beginning_of_sprint(sprint) + sprint_length_in_days.days).end_of_day
  end

  def estimatable_stories
    if !estimate_bugs? && !estimate_chores?
      return stories.where("type = 'Feature'")
    elsif project.estimate_bugs?
      return stories.where("type != 'Chore'")
    elsif project.estimate_chores?
      return stories.where("type != 'Bug'")
    end
    nil
  end
end
