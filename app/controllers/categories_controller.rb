class CategoriesController < ApplicationController
  before_action :authenticate
  before_action :verify_destroyer, only: [:destroy]

  def new
    @category = Category.new
  end

  def show
    # @category = Category.find_by(title: params[:title])
    @category = Category.find_by("LOWER(title) = ?", params[:id])
    @posts = @category.posts.order(created_at: :desc)
  end

  def index
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = t 'flash.category_created'
      redirect_to categories_path
    end
  end

  def destroy
    @category = Category.find(params[:id])
    
    @category.posts.update_all(category_id: nil)
    @category.delete
    flash.now[:success] = (t :category_deleted)
  end

  private

    def authenticate
      authenticate_with_redirect('flash.authenticate_add_category')
    end

    def verify_destroyer
      if !current_user.admin
        redirect_to root_url, status: :see_other
      end
    end

    def category_params
      params.require(:category).permit(:title, :description)
    end
end
