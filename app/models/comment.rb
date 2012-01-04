class Comment < ActiveRecord::Base
  belongs_to :workable_item

  before_create :add_posted_by
  after_create :add_workable_item_history

  validates_presence_of :comment

  def owner
    self.posted_by.present? ? User.find(self.posted_by) : nil
  end

  private

  def add_workable_item_history
    self.workable_item.add_history("added comment : " + comment)
  end

  def add_posted_by
    self.posted_by = User.current_user.id
  end


end
