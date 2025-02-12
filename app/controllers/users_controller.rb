class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]
  before_action :authorize_admin, only: [:destroy]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    redirect_to root_url if @user.nil?

    if @user == current_user
      render :profile
    else
      render :show
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])

    @user.destroy
    flash.now[:success] = (t 'flash.user_deleted', username: @user.username)
  end

  private

  def user_params
    params.require(:user)
          .permit(:username, :email, :password, :password_confirmation)
  end

  def authorize_admin
    return if current_user&.admin

    redirect_to root_url, status: :see_other
  end
end
