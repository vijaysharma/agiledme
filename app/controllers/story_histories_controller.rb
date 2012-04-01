class StoryHistoriesController < ApplicationController
  # GET /story_histories
  # GET /story_histories.xml
  def index
    @story_histories = StoryHistory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @story_histories }
    end
  end


end
