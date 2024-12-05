class ApplicationController < ActionController::Base
    helper_method :logged_in?, :current_user, :logout

  
    def logged_in?
        User.exists?(id: session[:user_id])
    end

    def current_user 
        if !!session[:user_id]
            current_user ||= User.find_by(id: session[:user_id])
        end
    end

    def logout
        @user = current_user
        session[:user_id] = nil
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
end
