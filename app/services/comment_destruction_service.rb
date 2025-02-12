class CommentDestructionService
  attr_reader :partial

  def initialize(comment)
    @comment = comment
  end

  def call
    if children?
      @comment.update_attribute(:hidden, true)
      @partial = 'comments/comment'
    else
      @comment.destroy

      clean_up_ancestors(@comment)
      @partial = 'shared/empty_partial'
    end
  end

  private

  def children?
    @comment.subcomments.any?
  end

  def clean_up_ancestors(comment)
    parent = comment.parent
    return if parent.nil?

    if parent.hidden? && parent.subcomments.empty?
      parent.destroy
      clean_up_ancestors(parent)
    end
  end
end
