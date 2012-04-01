class StoryAttachmentsController < ApplicationController

  def download_attachment
    @story_attachment = StoryAttachment.find(params[:id])
    send_file("#{Rails.root}/public#{@story_attachment.image.url}",
              :filename => @story_attachment.image_file_name,
              :type => @story_attachment.content_type)
  end

  def create
    params[:story_attachment][:image] = params[:story_attachment][:image][0]
    @story_attachment = StoryAttachment.new(params[:story_attachment])
    @story_attachment.user_id= current_user.id
    if @story_attachment.save!
      respond_to do |format|
        format.html {
          render :json => [@story_attachment.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@story_attachment.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @picture = StoryAttachment.find(params[:id])
    @picture.destroy
    render :json => true
  end

end