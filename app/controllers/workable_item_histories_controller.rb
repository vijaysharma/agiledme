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

  # GET /workable_item_histories/1
  # GET /workable_item_histories/1.xml
  def show
    @workable_item_history = WorkableItemHistory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @workable_item_history }
    end
  end

  # GET /workable_item_histories/new
  # GET /workable_item_histories/new.xml
  def new
    @workable_item_history = WorkableItemHistory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @workable_item_history }
    end
  end

  # GET /workable_item_histories/1/edit
  def edit
    @workable_item_history = WorkableItemHistory.find(params[:id])
  end

  # POST /workable_item_histories
  # POST /workable_item_histories.xml
  def create
    @workable_item_history = WorkableItemHistory.new(params[:workable_item_history])

    respond_to do |format|
      if @workable_item_history.save
        format.html { redirect_to(@workable_item_history, :notice => 'Story history was successfully created.') }
        format.xml  { render :xml => @workable_item_history, :status => :created, :location => @workable_item_history }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @workable_item_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /workable_item_histories/1
  # PUT /workable_item_histories/1.xml
  def update
    @workable_item_history = WorkableItemHistory.find(params[:id])

    respond_to do |format|
      if @workable_item_history.update_attributes(params[:workable_item_history])
        format.html { redirect_to(@workable_item_history, :notice => 'Story history was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @workable_item_history.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workable_item_histories/1
  # DELETE /workable_item_histories/1.xml
  def destroy
    @workable_item_history = WorkableItemHistory.find(params[:id])
    @workable_item_history.destroy

    respond_to do |format|
      format.html { redirect_to(story_histories_url) }
      format.xml  { head :ok }
    end
  end
end
