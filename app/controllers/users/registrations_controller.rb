# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  if %w[development production].include?(Rails.env)
    before_action :check_captcha, only: [:create]
  end

  # PUT /resource
  # Default Devise logic,
  # except that now after edit, it rerenders profile page.
  def update #  rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      # Reloads profile page
      respond_with resource, location: user_path(current_user)
    else
      clean_up_passwords resource
      set_minimum_password_length

      # Reloads profile page with errors
      render turbo_stream: [
        turbo_stream.update('edit_username_form',
                            partial: 'users/edit_username_form'),
        turbo_stream.update('flash-messages', partial: 'layouts/flash')
      ]
    end
  end

  protected

  # Permit :username.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  # Allow to update user without password.
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  # change flash type to :success
  def set_flash_message_for_update(resource, prev_unconfirmed_email)
    return unless is_flashing_format?

    flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                  :update_needs_confirmation
                elsif sign_in_after_change_password?
                  :updated
                else
                  :updated_but_not_signed_in
                end
    set_flash_message :success, flash_key
  end

  def check_captcha # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    self.resource = resource_class.new(sign_up_params) if resource.nil?
    recaptcha_response = params.dig('g-recaptcha-response-data', 'signup')

    if recaptcha_response.blank?
      puts 'DEBUG: Captcha response is missing or empty!'
      resource.errors.add(:base, 'captcha response is missing')
      render :new, status: :unprocessable_entity
    end

    user_is_not_a_robot = verify_recaptcha(response: recaptcha_response,
                                           action: 'signup',
                                           minimum_score: 0.7)
    return if user_is_not_a_robot

    # If the score is too low, handle the failure
    puts "DEBUG: The reason for failure: #{recaptcha_failure_reason}"
    resource.errors.add(:base, (t 'flash.captcha_error'))
    render :new, status: :unprocessable_entity
  end
end
