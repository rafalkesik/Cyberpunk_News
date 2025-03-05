class CommentsController < ApplicationController
  before_action :authenticate
  before_action :authorize_destroyer, only: [:destroy]

  def new
    parent_id = comment_params[:comment_id]
    @parent = Comment.find(parent_id)
    @post   = @parent.post
  end

  def create # rubocop:disable Metrics/AbcSize
    @comment  = current_user.comments.build(comment_params)
    @parent   = @comment.parent
    @post     = @comment.post
    @comments = @post.comments.where.not(id: nil)

    if @comment.save
      flash.now[:success] = t 'flash.comment_created'
    else
      flash.now[:danger] = t 'flash.comment_not_valid'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    return if @comment.nil?

    destruction_service = CommentDestructionService.new(@comment)
    destruction_service.call
    @partial = destruction_service.partial

    flash.now[:success] = t 'flash.comment_deleted'
  end

  private

  def authenticate
    authenticate_with_flash('flash.authenticate_add_com')
  end

  def authorize_destroyer
    comment = Comment.find(params[:id])
    return if current_user&.admin ||
              current_user&.author_of_comment?(comment)

    redirect_to root_url, status: :see_other
  end

  def comment_params
    params.require(:comment).permit(:post_id,
                                    :content,
                                    :comment_id,
                                    :parent_id,
                                    :hidden)
  end

  def children?(comment)
    Comment.find_by(parent_id: comment.id)
  end
end
