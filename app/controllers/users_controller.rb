class UsersController < ApplicationController
    before_action :authenticate,    only: [:index, :show, :destroy]
    before_action :authorize, only: [:update]
    before_action :verify_admin, only: [:destroy]

    def new
        @user = User.new
    end

    def index
        @users = User.all 
    end

    def show
        @user = User.find_by(id: params[:id])
        @showing_current_user = @user == current_user

        if @user.nil?
            redirect_to root_url
        end
    end

    def create
        @user = User.new(user_params)
        if @user.valid?
            @user.save
            flash[:success] = "New user created & logged in."
            session[:user_id] = @user.id
            redirect_to @user
        else
            render "/sessions/login"
        end
    end

    def update
        @user = current_user
        if @user.update(user_params)
            flash[:success] = "Password updated."
            redirect_to user_url(@user), status: :see_other
        else
            flash.now[:danger] = "Passwords don't match."
            render "users/show"
        end
    end

    def destroy
        @user = User.find_by(id: params[:id])
        @user.destroy
        flash[:success] = "Successfully deleted user: #{@user.username}."
        redirect_to users_path, status: :see_other
    end

    private

    def user_params
        params.require(:user)
              .permit(:username, :password, :password_confirmation)
    end

    def authenticate
        unless logged_in?
            store_requested_location
            flash[:warning] = "Please log in to view that page."
            redirect_to login_url, status: :see_other
        end
    end

    def authorize
        requested_user_is_not_logged_in = params[:id] != current_user.id.to_s

        if requested_user_is_not_logged_in
            redirect_to root_url, status: :see_other
        end
    end

    def verify_admin
        user_is_not_admin = !current_user.admin
        
        if user_is_not_admin
            redirect_to root_url, status: :see_other
        end
    end
end
