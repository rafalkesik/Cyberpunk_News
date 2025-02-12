module CommentsHelper
  # Returns unlike or like icon partial
  # based on user's liking the comment or not.
  def comment_like_partial(comment, user)
    if user && comment.liked_by?(user)
      'comments/unlike_form'
    else
      'comments/like_form'
    end
  end
end
