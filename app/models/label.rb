class Label < ActiveRecord::Base
  belongs_to :workable_item
  has_many :workable_item_labels
end
