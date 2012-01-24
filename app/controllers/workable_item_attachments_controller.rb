class WorkableItemAttachmentsController < ApplicationController

  def download_attachment
    raise "came to download"
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.restart!
        format.js { render :template => 'workable_items/action_success' }
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' was successfully restarted.') }
        format.xml { head :ok }
      else
        format.html { redirect_to(project_url(@workable_item.project), :notice => @workable_item.type + ' ERROR.') }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

end
