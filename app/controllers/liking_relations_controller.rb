# Handles liking and unliking posts by users.
class LikingRelationsController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]

  def create
    @relation = LikingRelation.new(liking_relations_params)
    @relation.liking_user_id = current_user&.id
    @post = @relation.liked_post

    @relation.save if @relation.valid?
    respond_to do |format|
      format.html { redirect_back_or root_url }
      format.turbo_stream { }
    end
  end

  def destroy
    @user_id = current_user&.id
    @post_id = liking_relations_params[:liked_post_id]
    @post = Post.find(@post_id)
    @relation ||= LikingRelation.where(liking_user_id: @user_id,
                                       liked_post_id:  @post_id).first
    @relation&.destroy

    respond_to do |format|
      format.html { redirect_back_or root_url }
      format.turbo_stream { }
    end
  end

  private

    def liking_relations_params
      params.require(:liking_relation).permit(:liked_post_id)
    end

    def authenticate
      store_previous_location
      unless logged_in?
        flash[:warning] = 'You must be logged in to upvote.'
        redirect_to login_url, status: :see_other
      end
    end
end
