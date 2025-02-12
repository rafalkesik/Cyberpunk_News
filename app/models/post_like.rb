class PostLike < ApplicationRecord
  belongs_to :liking_user, class_name: '::User'
  belongs_to :liked_post,  class_name: '::Post'

  validates :liking_user, :liked_post, presence: true
end
