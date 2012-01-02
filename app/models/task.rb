class Task < ActiveRecord::Base
  belongs_to :workable_item

  include AASM

  validates_presence_of :description

  aasm_initial_state :new

  before_save :update_finished_by

  aasm :column => :status do
    state :new
    state :finished
  end

  private

  def update_finished_by
    if changed_attributes["status"].present?
      if changed_attributes["status"].eql?("new")
        self.finished_by = User.current_user.id
      else
        self.finished_by = nil
      end
    end
  end
end
