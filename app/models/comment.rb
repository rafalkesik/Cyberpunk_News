class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many   :comment_liking_relations, foreign_key: :liked_comment_id
  has_many   :liking_users, through: :comment_liking_relations,
                            source: :liking_user
  validates_presence_of :content

  def points
    self.comment_liking_relations.count
  end

  def is_liked_by?(user)
    !!my_liking_relation(user)
  end

  def my_liking_relation(user)
      comment_liking_relations.find_by(liking_user: user) if user
  end

  def icon_data(current_user)
    if self.is_liked_by?(current_user)
        { method: :delete, class: 'text-highlight' }
    else
        { method: :post, class: 'text-secondary' }
    end
  end
end
