class WorkableItemsController < ApplicationController
  # GET /workable_items
  # GET /workable_items.xml
  def index
    @project = Project.find(params[:project])
    @workable_items = @project.workable_items

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @workable_items }
    end
  end

  # GET /workable_items/1
  # GET /workable_items/1.xml
  def show
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @workable_item }
    end
  end

  # GET /workable_items/new
  # GET /workable_items/new.xml
  def new
#    @workable_item = initialize_workable_item(params[:type])
    @workable_item = WorkableItem.new
    @workable_item.type = params[:type]
    @workable_item.project = Project.find(params[:project])
    @workable_item.requester = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @workable_item }
    end
  end


  # GET /workable_items/1/edit
  def edit
    @workable_item = WorkableItem.find(params[:id])
  end

  # POST /workable_items
  # POST /workable_items.xml
  def create
    @workable_item = WorkableItem.new(params[:workable_item])
    @workable_item.type = params[:workable_item][:type]

    respond_to do |format|
      if @workable_item.save
        format.html { redirect_to(@workable_item, :notice => @workable_item.type + ' was successfully created.') }
        format.xml { render :xml => @workable_item, :status => :created, :location => @workable_item }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /workable_items/1
  # PUT /workable_items/1.xml
  def update
    @workable_item = WorkableItem.find(params[:id])

    respond_to do |format|
      if @workable_item.update_attributes(params[:workable_item])
        format.html { redirect_to(@workable_item, :notice => @workable_item.type + ' was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @workable_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workable_items/1
  # DELETE /workable_items/1.xml
  def destroy
    @workable_item = WorkableItem.find(params[:id])
    project = @workable_item.project
    @workable_item.destroy

    respond_to do |format|
      format.html { redirect_to(stories_url(:project => project)) }
      format.xml { head :ok }
    end
  end
end
