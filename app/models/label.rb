class Label < ActiveRecord::Base
  belongs_to :story
  has_many :story_labels

  self.include_root_in_json = false
end
