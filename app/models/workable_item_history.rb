class WorkableItemHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :workable_item
end
