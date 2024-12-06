class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many   :comment_liking_relations, foreign_key: :liked_comment_id
  has_many   :liking_users, through: :comment_liking_relations,
                            source: :liking_user
  validates_presence_of :content
end
