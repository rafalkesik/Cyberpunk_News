class ApplicationController < ActionController::Base

    def logged_in?
        !!session[:user_id]
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

    def nil?
        self === nil
    end
end
