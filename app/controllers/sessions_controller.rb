class SessionsController < ApplicationController
  include ApplicationHelper

  def login
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])

    if authenticated(@user)
      session[:user_id] = @user.id
      flash[:success] = t 'flash.logged_in'
      redirect_back_or @user
    else
      flash.now[:danger] = t 'flash.login_invalid'
    end
  end

  def destroy
    logout
    flash[:success] = t 'flash.logged_out'
    redirect_to root_url, status: :see_other
  end

  private

  def authenticated(user)
    user&.authenticate(params[:user][:password])
  end
end
