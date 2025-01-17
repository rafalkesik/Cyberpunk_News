class UsersController < ApplicationController
  before_action :authenticate, only: [:index, :show, :destroy]
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

    redirect_to root_url if @user.nil?
  end

  def create
    @user = User.new(user_params)

    return unless @user.save

    flash[:success] = t 'flash.user_created'
    session[:user_id] = @user.id
    redirect_to @user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      flash.now[:success] = t 'flash.pass_updated'
    else
      flash.now[:danger] = t 'flash.pass_different'
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
          .permit(:username, :password, :password_confirmation)
  end

  def authenticate
    authenticate_with_redirect('flash.authenticate')
  end

  def authorize
    requested_user_is_logged_in = params[:id] == current_user.id.to_s

    return if requested_user_is_logged_in

    redirect_to root_url, status: :see_other
  end

  def verify_admin
    return if current_user.admin

    redirect_to root_url, status: :see_other
  end
end
