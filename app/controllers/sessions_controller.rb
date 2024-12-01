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
      flash[:danger] = "Username or password are incorrect. Try again."
      redirect_to login_url, status: :see_other
    end
  end

  def destroy
    logout
    flash[:success] = "Logged out successfully."
    redirect_to root_url, status: :see_other
  end
end
