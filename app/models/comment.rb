class Comment < ActiveRecord::Base
  belongs_to :story

  before_create :add_posted_by
  after_create :add_story_history

  validates_presence_of :comment

  def owner
    self.posted_by.present? ? User.find(self.posted_by) : nil
  end

  private

  def add_story_history
    self.story.add_history("added comment : " + comment)
  end

  def add_posted_by
    self.posted_by = User.current_user.id
  end


end
