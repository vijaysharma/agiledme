class WorkableItemHistoriesController < ApplicationController
  # GET /workable_item_histories
  # GET /workable_item_histories.xml
  def index
    @workable_item_histories = WorkableItemHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @workable_item_histories }
    end
  end


end
