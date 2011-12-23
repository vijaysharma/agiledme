class Comment < ActiveRecord::Base
  belongs_to :workable_item
end
