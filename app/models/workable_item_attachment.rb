class WorkableItemAttachment < ActiveRecord::Base
  belongs_to :workable_item

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

end
