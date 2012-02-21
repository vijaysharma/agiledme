class WorkableItemAttachmentsController < ApplicationController

  def download_attachment
    @workable_item_attachment = WorkableItemAttachment.find(params[:id])
    send_file("#{Rails.root}/public#{@workable_item_attachment.image.url}",
              :filename => @workable_item_attachment.image_file_name,
              :type => @workable_item_attachment.content_type)
  end

  def create
    params[:workable_item_attachment][:image] = params[:workable_item_attachment][:image][0]
    @workable_item_attachment = WorkableItemAttachment.new(params[:workable_item_attachment])
    @workable_item_attachment.user_id= current_user.id
    if @workable_item_attachment.save!
      respond_to do |format|
        format.html {
          render :json => [@workable_item_attachment.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@workable_item_attachment.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = WorkableItemAttachment.find(params[:id])
    @picture.destroy
    render :json => true
  end

end