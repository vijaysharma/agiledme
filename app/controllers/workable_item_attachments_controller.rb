class WorkableItemAttachmentsController < ApplicationController

  def download_attachment
    @workable_item_attachment = WorkableItemAttachment.find(params[:id])
    send_file("#{Rails.root}/public#{@workable_item_attachment.image.url}",
              :filename => @workable_item_attachment.image_file_name,
              :type => @workable_item_attachment.content_type)
  end
end