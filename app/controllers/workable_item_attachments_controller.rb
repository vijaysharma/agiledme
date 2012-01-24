class WorkableItemAttachmentsController < ApplicationController

  def download_attachment
    @workable_item_attachment = WorkableItemAttachment.find(params[:id])
    send_file("#{Rails.root}/public/system/images/#{@workable_item_attachment.id}/original/#{@workable_item_attachment.image_file_name}",
              :filename => @workable_item_attachment.image_file_name,
              :type => @workable_item_attachment.image_content_type)
  end
end