class CommentsController < ApplicationController
  before_action :authenticate
  before_action :authorize_destroyer, only: [:destroy]

  def new
    parent_id = comment_params[:comment_id]
    @parent = Comment.find(parent_id)
    @post   = @parent.post
  end

  def create
    @comment      = Comment.new(comment_params)
    @comment.user = current_user
    @parent       = @comment.parent
    @post         = @comment.post
    @comments     = @post.comments.where.not(id: nil)
    @comment_has_no_parents = @parent.nil?
    
    if @comment.valid?
      @comment.save
      flash.now[:success] = t 'flash.comment_created'
    else
      flash.now[:danger] = t 'flash.comment_not_valid'
      render turbo_stream: [
        turbo_stream.update('flash-messages', partial: 'layouts/flash'),
        turbo_stream.update('submit-comment-form', partial: 'comments/submit_comment_form', locals: {post: @post})
      ]
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if has_children?(@comment)
      @comment.update_attribute(:hidden, true)
      @partial = 'comments/comment'
    else
      @comment&.destroy_and_its_parents_if_they_are_redundant
      @partial = 'shared/empty_partial'
    end
    flash.now[:success] = t 'flash.comment_deleted'
  end

  private

    def authenticate
      unless logged_in?
        store_previous_location
        flash.now[:warning] = t 'flash.authenticate_add_com'
        render turbo_stream: [
          turbo_stream.update('flash-messages',
                              partial: 'layouts/flash')
        ]
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
                                      :content,
                                      :comment_id,
                                      :parent_id,
                                      :hidden)
    end

    def has_children?(comment)
      Comment.find_by(parent_id: comment.id)
    end
end
