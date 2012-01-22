class LabelsController < ApplicationController
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
end
