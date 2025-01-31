# Handles liking and unliking posts by users.
class LikingRelationsController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]

  def create
    @relation = LikingRelation.new(liking_relations_params)
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
    @post_id = liking_relations_params[:liked_post_id]
    @post = Post.find(@post_id)
    @relation ||= LikingRelation.where(liking_user_id: @user_id,
                                       liked_post_id: @post_id).first
    @relation&.destroy
  end

  private

  def liking_relations_params
    params.require(:liking_relation).permit(:liked_post_id)
  end

  def authenticate
    authenticate_with_flash('flash.authenticate_like')
  end
end
