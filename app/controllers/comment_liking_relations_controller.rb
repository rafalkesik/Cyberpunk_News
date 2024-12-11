class CommentLikingRelationsController < ApplicationController
  before_action :authenticate
  before_action :authorize

  def create
    @relation     = CommentLikingRelation.new(comment_relation_params)
    @post         = @relation.liked_comment&.post
    @comment      = @relation.liked_comment
    @current_user = current_user
    if @relation.valid?
      @relation.save
    else
      flash.now[:danger] = "The comment has been deleted."
      render turbo_stream: [
        turbo_stream.update("flash-messages", partial: 'layouts/flash')
      ]
    end
  end

  def destroy
    @relation = CommentLikingRelation.where(comment_relation_params).first
    if @relation
      @comment  = @relation.liked_comment
      @current_user = current_user
      @relation.destroy
    else
      flash[:danger] = "The comment has been deleted."
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def authenticate
      unless logged_in?
        store_previous_location
        flash.now[:warning] = 'You must be logged in to upvote.'
        render turbo_stream: [
          turbo_stream.update('flash-messages',
                              partial: 'layouts/flash')
        ]
      end
    end

    def authorize
      @user = User.find(comment_relation_params[:liking_user_id])
      unless @user == current_user
        flash.now[:warning] = 'You must log in to like.'
        render turbo_stream: [
          turbo_stream.update('flash-messages', partial: 'layouts/flash')
        ]
      end
    end

    def comment_relation_params
      params.require(:comment_liking_relation).permit(:liked_comment_id,
                                                      :liking_user_id)
    end
end
