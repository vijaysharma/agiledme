class Users::RegistrationsController < Devise::RegistrationsController

  def create
    delete_user_if_already_existing_by_invitation()
    super
  end

  private

  def delete_user_if_already_existing_by_invitation
    user = User.find_by_email(params[resource_name][:email])
    if (user.present? and user.not_accepted_the_invitation?)
      user.delete
    end
  end

end