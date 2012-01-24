class WorkableItemAttachment < ActiveRecord::Base
  belongs_to :workable_item
  belongs_to :user

  has_attached_file :image, :styles => {:thumb => "72x52>" }

end
