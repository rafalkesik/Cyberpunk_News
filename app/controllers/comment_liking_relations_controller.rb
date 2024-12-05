class CommentLikingRelationsController < ApplicationController
  before_action :authenticate

  def create
    @relation = CommentLikingRelation.new(comment_relation_params)
    @relation.liking_user = current_user
    @post = @relation.liked_comment&.post
    if @relation.valid?
      @relation.save
      flash.now[:success] = "Comment liked."
    else
      flash.now[:danger] = "The post has been deleted."
    end
  end

  private

    def authenticate
      unless logged_in?
        store_previous_location
        flash[:warning] = 'You must be logged in to upvote.'
        redirect_to login_url, status: :see_other
      end
    end

    def comment_relation_params
      params.require(:comment_liking_relation).permit(:liked_comment_id)
    end
end
