module PostsHelper
  # Returns downvote or upvote icon partial
  # based on user's liking the post or not.
  def post_vote_partial(post, user)
    if post.liked_by?(user)
      'posts/downvote_form'
    else
      'posts/upvote_form'
    end
  end

  # returns true if user should be able to delete a post
  def can_delete_post(post)
    current_user&.admin ||
      (current_user&.author_of_post?(post) &&
       current_url == user_url(current_user))
  end

  # returns true if user should be able to delete a comment
  def can_delete_comment(comment)
    return false if comment.hidden
    return false unless current_user

    current_user.author_of_comment?(comment) || current_user.admin
  end

  # returns author or 'someone' if hidden
  def render_author(comment)
    if comment.hidden
      content_tag(:span, (t :someone), class: 'text-emphasize')
    else
      link_to comment.user.username,
              user_path(comment.user),
              class: 'text-emphasize',
              data: { turbo_frame: '_top' }
    end
  end
end
