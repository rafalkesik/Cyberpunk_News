class CommentLikingRelationsController < ApplicationController
  before_action :authenticate

  def create
    @relation     = CommentLikingRelation.new(comment_relation_params)
    @relation.liking_user_id = current_user&.id
    @comment      = @relation.liked_comment
    @post         = @comment&.post
    @current_user = current_user
    if @relation.valid?
      @relation.save
    else
      flash.now[:danger] = t 'flash.comment_deleted'
      render turbo_stream: [
        turbo_stream.update("flash-messages", partial: 'layouts/flash')
      ]
    end
  end

  def destroy
    @relation = CommentLikingRelation.find_by(liked_comment_id: comment_relation_params[:liked_comment_id], liking_user_id: current_user&.id)
    @comment  = @relation.liked_comment
    @current_user = current_user
    @relation&.destroy
  end

  private

    def authenticate
      unless logged_in?
        store_previous_location
        flash.now[:warning] = t 'flash.authenticate_like'
        render turbo_stream: [
          turbo_stream.update('flash-messages',
                              partial: 'layouts/flash')
        ]
      end
    end

    def comment_relation_params
      params.require(:comment_liking_relation).permit(:liked_comment_id)
    end
end
