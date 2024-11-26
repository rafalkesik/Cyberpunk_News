class ApplicationController < ActionController::Base
    helper_method :logged_in?, :current_user, :logout,
                  :current_user_is_admin, :current_user_is_post_author


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

    def current_user_is_admin
        logged_in? && current_user.admin
    end

    def current_user_is_post_author(post)
      logged_in? && current_user == post.user
    end
end
