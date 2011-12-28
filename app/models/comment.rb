class Comment < ActiveRecord::Base
  belongs_to :workable_item
  after_create :add_workable_item_history

  private

  def add_workable_item_history
    self.workable_item.add_history("added comment : " + comment)
  end


end
