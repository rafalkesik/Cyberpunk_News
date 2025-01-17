class CategoriesController < ApplicationController
  before_action :authenticate,     only: [:new, :create, :destroy]
  before_action :verify_destroyer, only: [:destroy]

  def new
    @category = Category.new
  end

  def show
    # @category = Category.find_by(title: params[:title])
    @category = Category.find_by(slug: params[:slug])
    @posts = @category.posts.order(created_at: :desc)
  end

  def index
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)

    return unless @category.save

    flash[:success] = t 'flash.category_created'
    redirect_to categories_path, status: :see_other
  end

  def destroy
    @category = Category.find_by(slug: params[:slug])

    @category.posts.update_all(category_id: 1)
    @category.delete
    flash.now[:success] = (t :category_deleted)
  end

  private

  def authenticate
    authenticate_with_redirect('flash.authenticate_add_category')
  end

  def verify_destroyer
    return if current_user.admin

    redirect_to root_url, status: :see_other
  end

  def category_params
    params.require(:category).permit(:title, :slug, :description)
  end
end
