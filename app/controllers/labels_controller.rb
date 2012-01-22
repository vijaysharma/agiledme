class LabelsController < ApplicationController
  # GET /labels
  # GET /labels.xml
  def index
    @project = Project.find(params[:project_id])

    @labels = @project.labels.where("name like ? ", "%#{params[:q]}%")
    @labels << {:name => "Add: #{params[:q]}", :id => "CREATE_#{params[:q]}_END"} if @labels.blank?


    respond_to do |format|
      format.html
      format.json { render :json => @labels }
      format.xml { render :xml => @labels }
    end
  end

  # GET /labels/1
  # GET /labels/1.xml
  def show
    @label = Label.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @label }
    end
  end

  # GET /labels/new
  # GET /labels/new.xml
  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @label }
    end
  end

  # GET /labels/1/edit
  def edit
    @label = Label.find(params[:id])
  end

  # POST /labels
  # POST /labels.xml
  def create
    @label = Label.new(params[:label])

    respond_to do |format|
      if @label.save
        format.html { redirect_to(@label, :notice => 'Label was successfully created.') }
        format.xml { render :xml => @label, :status => :created, :location => @label }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /labels/1
  # PUT /labels/1.xml
  def update
    @label = Label.find(params[:id])

    respond_to do |format|
      if @label.update_attributes(params[:label])
        format.html { redirect_to(@label, :notice => 'Label was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @label.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.xml
  def destroy
    @label = Label.find(params[:id])
    @label.destroy

    respond_to do |format|
      format.html { redirect_to(labels_url) }
      format.xml { head :ok }
    end
  end
end
