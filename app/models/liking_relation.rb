# Represents a relationship where a user likes a specific post.
# It links a liking user to a liked post, establishing a many-to-many
# relationship via `User` and `Post`.
# Enables methods such as post.liking_users or user.liked_posts.
class LikingRelation < ApplicationRecord
  belongs_to :liking_user, class_name: '::User'
  belongs_to :liked_post,  class_name: '::Post'

  validates :liking_user, :liked_post, presence: true
end
