class WorkableItemLabel < ActiveRecord::Base
  belongs_to :workable_item
  belongs_to :label
end
