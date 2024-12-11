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
      flash.now[:danger] = "Username or password are incorrect. Try again."
      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'layouts/flash')
      ]
    end
  end

  def destroy
    logout
    flash[:success] = "Logged out successfully."
    redirect_to root_url, status: :see_other
  end
end
