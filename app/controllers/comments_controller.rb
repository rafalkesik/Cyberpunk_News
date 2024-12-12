class CommentsController < ApplicationController
  before_action :authenticate
  before_action :authorize_destroyer, only: [:destroy]

  def create
    @comment  = Comment.new(comment_params)
    @post     = @comment.post
    @comments = @post.comments.where.not(id: nil)
    @comment.user = current_user
    
    if @comment.valid?
      @comment.save
      flash.now[:success] = "Comment submitted."
    else
      flash.now[:danger] = "Comment not valid."
      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'layouts/flash'),
        turbo_stream.update('submit-comment-form', partial: 'comments/submit_comment_form', locals: {post: @post})
      ]
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment&.destroy
    flash.now[:success] = "Comment deleted"
  end

  private

    def authenticate
      unless logged_in?
        store_previous_location
        flash[:warning] = "Log in to submit comments."
        redirect_to login_url, status: :see_other
      end
    end

    def authorize_destroyer
      comment = Comment.find(params[:id])
      unless current_user&.admin? || current_user&.is_author_of_comment(comment)
        redirect_to root_url, status: :see_other
      end
    end

    def comment_params
      params.require(:comment).permit(:post_id,
                                      :content)
    end
end
