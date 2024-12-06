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
      flash.now[:success] = "Comment liked."
    else
      flash.now[:danger] = "The post has been deleted."
    end
  end

  def destroy
    @relation = CommentLikingRelation.find_by(comment_relation_params)
    @comment  = @relation.liked_comment
    @current_user = current_user
    @relation&.destroy
  end

  private

    def authenticate
      unless logged_in?
        store_previous_location
        flash[:warning] = 'You must be logged in to upvote.'
        redirect_to login_url, status: :see_other
      end
    end

    def authorize
      @user = User.find(comment_relation_params[:liking_user_id])
      unless @user == current_user
        flash[:warning] = 'You must log in to like.'
        redirect_to root_url, status: :see_other
      end
    end

    def comment_relation_params
      params.require(:comment_liking_relation).permit(:liked_comment_id,
                                                      :liking_user_id)
    end
end
