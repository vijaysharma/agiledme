class WorkableItemAttachment < ActiveRecord::Base
  belongs_to :workable_item
  belongs_to :user

  mount_uploader :image, ImageUploader

  before_save :update_image_attributes

  def image_file_name
    File.basename(self.image.url)
  end

  private

  def update_image_attributes
    if image.present? && image_changed?
      self.content_type = image.file.content_type
    end
  end

end
