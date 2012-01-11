class Users::InvitationsController < Devise::InvitationsController

  def index
    @project = Project.find(params[:project])

    respond_to do |format|
      format.html
    end
  end

  def create
    self.resource = resource_class.invite!(params[resource_name].merge({:role => "member", :initials => "SKM", :name => "Sanjeev Kumar Mishra"}), current_inviter)
    self.resource.inspect

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions, :email => self.resource.email
      respond_with resource, :location => after_invite_path_for(resource)
    else
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

end