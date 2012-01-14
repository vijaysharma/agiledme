module Devise
  module Models
    module Confirmable
      handle_asynchronously :send_confirmation_instructions
    end

    module Recoverable
      handle_asynchronously :send_reset_password_instructions
    end

    module Lockable
      handle_asynchronously :send_unlock_instructions
    end

    module Invitable
      handle_asynchronously :deliver_invitation
    end
  end
end