class DashboardController < ApplicationController

  def index
    @projects = current_user.projects
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end
end
