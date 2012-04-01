class StoryLabel < ActiveRecord::Base
  belongs_to :story
  belongs_to :label
end
