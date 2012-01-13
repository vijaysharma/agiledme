class Users::InvitationsController < Devise::InvitationsController

  # PUT /resource/invitation
  def update
    raise "I am coming here"
    self.resource = resource_class.accept_invitation!(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  end

end