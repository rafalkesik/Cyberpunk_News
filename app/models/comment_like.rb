class CommentLike < ApplicationRecord
  belongs_to :liking_user,   class_name: 'User'
  belongs_to :liked_comment, class_name: 'Comment'

  validates :liking_user, :liked_comment, presence: true
end
