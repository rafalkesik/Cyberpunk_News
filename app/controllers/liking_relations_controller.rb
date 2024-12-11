# Handles liking and unliking posts by users.
class LikingRelationsController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]
  before_action :authorize_unliking_user, only: [:destroy]

  def create
    @relation     = LikingRelation.new(liking_relations_params)
    @post         = @relation.liked_post
    @current_user = current_user

    @relation.save if @relation.valid?
  end

  def destroy
    @post = Post.find(liking_relations_params[:liked_post_id])    
    @current_user = current_user
    @relation ||= LikingRelation.where(liking_user_id: @current_user.id,
                                       liked_post_id:  @post.id).first

    @relation&.destroy

    respond_to do |format|
      format.html { redirect_back_or root_url }
      format.turbo_stream { }
    end
  end

  private

    def liking_relations_params
      params.require(:liking_relation).permit(:liking_user_id, :liked_post_id)
    end

    def authenticate
      store_previous_location
      unless logged_in?
        flash.now[:warning] = 'You must be logged in to upvote.'
        render turbo_stream: [
          turbo_stream.update('flash-messages', partial: 'layouts/flash'),
        ]
      end
    end

    def authorize_unliking_user
      store_previous_location
      if current_user_has_not_liked_this_post
        redirect_back_or root_url
      end
    end

    def current_user_has_not_liked_this_post
      user_id = liking_relations_params[:liking_user_id]
      user_id != current_user.id.to_s
    end
end
