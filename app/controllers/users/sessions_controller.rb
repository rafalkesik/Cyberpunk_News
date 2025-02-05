# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  # change flash type to :success
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:success, :signed_in)
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
