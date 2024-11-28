# Handles liking and unliking posts by users.
class LikingRelationsController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]
  before_action :authorize_unliking_user, only: [:destroy]

  def create
    @relation = LikingRelation.new(liking_relations_params)

    @relation.save if @relation.valid?
    redirect_back_or root_url
  end

  def destroy
    @user_id = liking_relations_params[:liking_user_id]
    @post_id = liking_relations_params[:liked_post_id]
    @relation = params[:id]
    @relation ||= LikingRelation.where(liking_user_id: @user_id,
                                       liked_post_id:  @post_id).first

    @relation&.destroy
    redirect_back_or root_url
  end

  private

    def liking_relations_params
      params.require(:liking_relation).permit(:liking_user_id, :liked_post_id)
    end

    def authenticate
      store_previous_location
      unless logged_in?
        flash[:warning] = 'You must be logged in to upvote.'
        redirect_to login_url, status: :see_other
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
