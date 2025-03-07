# Handles liking and unliking posts by users.
class PostLikesController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]

  def create
    @relation = PostLike.new(post_like_params)
    @relation.liking_user_id = current_user&.id
    @post = @relation.liked_post

    return if @relation.save

    flash.now[:danger] = t 'flash.post_deleted'
    render turbo_stream: [
      turbo_stream.update('flash-messages', partial: 'layouts/flash')
    ]
  end

  def destroy
    @user_id = current_user&.id
    @post_id = post_like_params[:liked_post_id]
    @post = Post.find(@post_id)
    @relation ||= PostLike.where(liking_user_id: @user_id,
                                 liked_post_id: @post_id).first
    @relation&.destroy
  end

  private

  def post_like_params
    params.require(:post_like).permit(:liked_post_id)
  end

  def authenticate
    authenticate_with_flash('flash.authenticate_like')
  end
end
