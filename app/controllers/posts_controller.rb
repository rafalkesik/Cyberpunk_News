class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :verify_destroyer,   only: [:destroy]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post          = Post.find(params[:id])
    @root_comments = @post.comments.where.not(id: nil).where(parent_id: nil)
    @new_comment   = @post.comments.build
    @parent        = nil
  end

  def new
    @post = Post.new
    @post.category_id = params[:category_id] if params[:category_id].present?
  end

  def create
    @user = current_user
    @post = @user.posts.build(post_params)

    return unless @post.save

    flash[:success] = t 'flash.post_created'
    redirect_to posts_url, status: :see_other
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy
    flash.now[:success] = t 'flash.post_deleted'
    return unless request.referrer == post_url(@post)

    redirect_to root_url, status: :see_other
  end

  private

  def authenticate
    authenticate_with_redirect('flash.authenticate_add_post')
  end

  def verify_destroyer
    @post = Post.find(params[:id])

    return if current_user&.admin? || current_user&.author_of_post?(@post)

    redirect_to root_url, status: :see_other
  end

  def post_params
    params[:post]&.permit(:title, :content, :link, :category_id)
  end
end
