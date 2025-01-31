class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in? # Ensure Devise helpers are available in views
  around_action :switch_locale

  # Changes language for every action based on :locale param
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # Pass on a :locale param to every path, url in links.
  def default_url_options
    { locale: I18n.locale }
  end

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

  def authenticate_with_flash(message)
    return if user_signed_in?

    flash.now[:warning] = t message
    render turbo_stream: [
      turbo_stream.update('flash-messages',
                          partial: 'layouts/flash')
    ]
  end
end
