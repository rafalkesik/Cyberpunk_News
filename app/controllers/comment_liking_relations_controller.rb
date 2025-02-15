class CommentLikingRelationsController < ApplicationController
  before_action :authenticate

  def create
    @relation = CommentLikingRelation.new(comment_relation_params)
    @relation.liking_user_id = current_user&.id
    @comment = @relation.liked_comment

    return if @relation.save

    flash.now[:danger] = t 'flash.comment_deleted'
  end

  def destroy
    @relation = CommentLikingRelation.find_by(
      liked_comment_id: comment_relation_params[:liked_comment_id],
      liking_user_id: current_user&.id
    )
    @comment = @relation.liked_comment
    @current_user = current_user
    @relation&.destroy
  end

  private

  def authenticate
    authenticate_with_flash('flash.authenticate_like')
  end

  def comment_relation_params
    params.require(:comment_liking_relation).permit(:liked_comment_id)
  end
end
