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

  # GET /story_histories/1
  # GET /story_histories/1.xml
  def show
    @story_history = StoryHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story_history }
    end
  end

  # GET /story_histories/new
  # GET /story_histories/new.xml
  def new
    @story_history = StoryHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story_history }
    end
  end

  # GET /story_histories/1/edit
  def edit
    @story_history = StoryHistory.find(params[:id])
  end

  # POST /story_histories
  # POST /story_histories.xml
  def create
    @story_history = StoryHistory.new(params[:story_history])

    respond_to do |format|
      if @story_history.save
        format.html { redirect_to(@story_history, :notice => 'Story history was successfully created.') }
        format.xml  { render :xml => @story_history, :status => :created, :location => @story_history }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /story_histories/1
  # PUT /story_histories/1.xml
  def update
    @story_history = StoryHistory.find(params[:id])

    respond_to do |format|
      if @story_history.update_attributes(params[:story_history])
        format.html { redirect_to(@story_history, :notice => 'Story history was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /story_histories/1
  # DELETE /story_histories/1.xml
  def destroy
    @story_history = StoryHistory.find(params[:id])
    @story_history.destroy

    respond_to do |format|
      format.html { redirect_to(story_histories_url) }
      format.xml  { head :ok }
    end
  end
end
