class CommentsController < ApplicationController
  before_action :authenticate

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @post    = @comment.post
    if @comment.valid?
      puts "Saving comment..."
      @comment.save
      flash[:success] = "Comment submitted."
      redirect_to post_path(@post), status: :see_other
    else
      puts "Comment not valid."
      flash.now[:danger] = "Comment not valid."
      render 'posts/show'
    end
  end

  def destroy
  end

  private

    def authenticate
      if !logged_in?
        store_previous_location
        flash[:warning] = "Log in to submit comments."
        redirect_to login_url, status: :see_other
      end
    end

    def comment_params
      params.require(:comment).permit(:post_id,
                                      :content)
    end
end
