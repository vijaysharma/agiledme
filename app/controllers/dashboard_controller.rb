class DashboardController < ApplicationController

  def index
    @projects = current_user.projects
    @user_project_activities = current_user.all_story_histories_for_all_my_projects.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @projects }
    end
  end
end
