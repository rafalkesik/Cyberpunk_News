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
            respond_to do |format|
                format.html { render "/sessions/login" }
                format.turbo_stream do
                    render turbo_stream: turbo_stream.update('new_user',partial: 'users/sign_up_form')
                end
            end
        end
    end

    def update
        @user = current_user
        if @user.update(user_params)
            respond_to do |format|
                format.html do
                    redirect_to user_url(@user), status: :see_other,
                                flash: { success: "Password updated." }
                end
                format.turbo_stream do
                    flash.now[:success] = "Password updated."
                end
            end
        else
            respond_to do |format|
                format.html do
                    render 'users/show',
                            status: :unprocessable_entity,
                            flash: { danger: "Passwords don't match." }
                end
                format.turbo_stream do
                    flash.now[:danger] = "Passwords don't match."
                end
            end
        end
    end

    def destroy
        @user = User.find_by(id: params[:id])
        @user.destroy
        msg = "Successfully deleted user: #{@user.username}."
        respond_to do |format|
          format.html { redirect_to users_path, status: :see_other,
                        flash: { success: msg } }
          format.turbo_stream { flash.now[:success] = msg }
        end
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
