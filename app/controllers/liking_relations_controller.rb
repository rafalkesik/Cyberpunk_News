# Handles liking and unliking posts by users.
class LikingRelationsController < ApplicationController
  before_action :authenticate, only: [:create, :destroy]
  before_action :authorize_unliking_user, only: [:destroy]

  def create
    @relation     = LikingRelation.new(liking_relations_params)
    @post         = @relation.liked_post
    @current_user = current_user

    @relation.save if @relation.valid?
    respond_to do |format|
      format.html { redirect_back_or root_url }
      format.turbo_stream { }
    end
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
      requesting_with_turbo_stream = request.headers['Turbo-Frame']

      store_previous_location
      unless logged_in?
        if requesting_with_turbo_stream
          flash.now[:warning] = 'You must be logged in to upvote.'
          post = Post.find(params[:liking_relation][:liked_post_id])
          render turbo_stream: [
            turbo_stream.update('flash-messages', partial: 'layouts/flash'),
            turbo_stream.update("post-#{post.id}-upvote",
                                partial: 'posts/upvote_form', 
                                locals: { post: post,
                                          data: { method: :post,
                                                  class: 'text-secondary' } } )
          ]
        else
          flash[:warning] = 'You must be logged in to upvote.'
          redirect_to login_url, status: :see_other
        end
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
