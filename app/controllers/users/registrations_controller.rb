class Users::RegistrationsController < Devise::RegistrationsController

  def create
    user = User.find_by_email(params[resource_name][:email])
    if (user.present? and user.not_accepted_the_invitation?)
      user.delete
    end
    super
  end

end