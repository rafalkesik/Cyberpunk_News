class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :subcomments, class_name: 'Comment',
                         foreign_key: :parent_id,
                         dependent: :destroy
  belongs_to :parent,    class_name: 'Comment', optional: true
  has_many :comment_likes, foreign_key: :liked_comment_id,
                           dependent: :destroy
  has_many :liking_users,  through: :comment_likes,
                           source: :liking_user
  validates_presence_of :content

  def points
    liking_users.count
  end

  def liked_by?(user)
    # liking_users.include(user)
    self.comment_likes.find_by(liking_user: user).present?
  end

  def destroy_and_its_parents_if_they_are_redundant
    destroy
    return unless had_no_siblings && parent&.hidden

    parent.destroy_and_its_parents_if_they_are_redundant
  end

  def had_no_siblings
    parent&.subcomments&.count&.zero?
  end
end
