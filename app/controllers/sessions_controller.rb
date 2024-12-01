class SessionsController < ApplicationController
  include ApplicationHelper

  def login
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      flash[:success] = "Logged in successfully."
      redirect_back_or @user
    else
      respond_to do |format|
        alert = "Username or password are incorrect. Try again."
        format.html {redirect_to login_url,
                     status: :see_other,
                     danger: alert }
        format.turbo_stream do
          flash.now[:danger] = alert
          render turbo_stream: turbo_stream.update('flash-messages', partial: 'layouts/flash')
        end
      end
    end
  end

  def destroy
    logout
    flash[:success] = "Logged out successfully."
    redirect_to root_url, status: :see_other
  end
end
