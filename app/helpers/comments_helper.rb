module CommentsHelper
  # Returns downvote or upvote icon partial
  # based on user's liking the comment or not.
  def comment_vote_partial(comment, user)
    if comment.liked_by?(user)
      'comments/downvote_form'
    else
      'comments/upvote_form'
    end
  end
end
