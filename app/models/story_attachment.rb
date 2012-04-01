class StoryAttachment < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :story
  belongs_to :user

  mount_uploader :image, ImageUploader

  before_save :update_image_attributes

  def image_file_name
    File.basename(self.image.url)
  end

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => image_file_name,
      "size" => self.image.size,
      "url" => self.image.url,
      "thumbnail_url" => self.image.thumb.url,
      "delete_url" => story_attachment_path(:id => id),
      "delete_type" => "DELETE"
    }
  end

  private

  def update_image_attributes
    if image.present? && image_changed?
      self.content_type = image.file.content_type
    end
  end

end
