# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # Allows to reset password when logged in.
  skip_before_action :require_no_authentication, only: [:create]

  protected

  # If logged in, redirects to profile.
  def after_sending_reset_password_instructions_path_for(resource_name)
    if user_signed_in?
      user_path(current_user)
    else
      super # Default behavior (redirects to login page)
    end
  end
end
