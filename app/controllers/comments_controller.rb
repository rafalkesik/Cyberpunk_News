class CommentsController < ApplicationController

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

    def comment_params
      params.require(:comment).permit(:post_id,
                                      :content)
    end
end
