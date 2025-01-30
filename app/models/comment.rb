class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many   :subcomments, class_name: 'Comment',
                           foreign_key: :parent_id,
                           dependent: :destroy
  belongs_to :parent,      class_name: 'Comment', optional: true
  has_many   :comment_liking_relations, foreign_key: :liked_comment_id,
                                        dependent: :destroy
  has_many   :liking_users, through: :comment_liking_relations,
                            source: :liking_user
  validates_presence_of :content

  def points
    self.comment_liking_relations.count
  end

  def liked_by?(user)
    !!my_liking_relation(user) # Should become .present?
  end

  def my_liking_relation(user)
    comment_liking_relations.find_by(liking_user: user) if user
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
