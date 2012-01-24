class WorkableItemAttachment < ActiveRecord::Base
  belongs_to :workable_item

  has_attached_file :image, :styles => {:thumb => "72x52>" }

end
