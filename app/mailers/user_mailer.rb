class UserMailer < ActionMailer::Base
  default :from => "support@whiteapple.com"

  def join_project_invitation(user, project, invited_by)
    @user =user
    @project = project
    @invited_by = invited_by

    mail(:template_path => 'users/mailer',
         :template_name => 'join_project_invitation',
         :to => user.email,
         :subject => "WHITE APPLE : Invitation to join the Project : #{project.name}")
  end

end
