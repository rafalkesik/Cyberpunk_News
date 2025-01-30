class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user, :logout
  around_action :switch_locale

  helper_method :current_user, :user_signed_in? # Ensure Devise helpers are available in views

  # Changes language for every action based on :locale param
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # Pass on a :locale param to every path, url in links.
  def default_url_options
    { locale: I18n.locale }
  end

  # def logged_in?
  #   User.exists?(id: session[:user_id])
  # end

  # def current_user
  #   return unless session[:user_id]

  #   User.find_by(id: session[:user_id])
  # end

  # def logout
  #   @user = current_user
  #   session[:user_id] = nil
  # end

  def store_requested_location
    session[:return_to] = request.url
  end

  def store_previous_location
    session[:return_to] = request.referrer
  end

  def redirect_back_or(fallback_path)
    redirect_to(session[:return_to] || fallback_path, status: :see_other)
    session[:return_to] = nil
  end

  def authenticate_with_redirect(message)
    return if logged_in?

    store_requested_location
    flash[:warning] = t message
    redirect_to login_url, status: :see_other
  end

  def authenticate_with_flash(message)
    return if logged_in?

    store_previous_location
    flash.now[:warning] = t message
    render turbo_stream: [
      turbo_stream.update('flash-messages',
                          partial: 'layouts/flash')
    ]
  end
end
