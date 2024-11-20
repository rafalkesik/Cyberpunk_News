class UsersController < ApplicationController
    include ApplicationHelper
    before_action :authorize,    only: [:show, :destroy]
    before_action :authenticate, only: [:update]
    before_action :verify_admin, only: [:destroy]

    def new
        @user = User.new
    end

    def index
        @users = User.all 
    end

    def show
        @user = User.find_by(id: params[:id])
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

    def authorize
        if session[:user_id].nil?
            flash[:warning] = "Please log in to view that page."
            redirect_to login_url, status: :see_other
        end
    end

    def authenticate
        if params[:id] != current_user.id.to_s
            redirect_to root_url, status: :see_other
        end
    end

    def verify_admin
        if !current_user.admin
            redirect_to root_url, status: :see_other
        end
    end
end
