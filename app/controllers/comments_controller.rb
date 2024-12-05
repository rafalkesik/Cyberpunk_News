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
      flash[:success] = "Comment submitted."
      redirect_to post_url(@post), status: :see_other
    else
      flash.now[:danger] = "Comment not valid."
      render 'posts/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment
      @comment.destroy
      flash[:success] = "Comment deleted"
      redirect_to post_url(@comment.post), status: :see_other
    end
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
