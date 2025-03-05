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

  before_validation :sanitize_content
  validates_presence_of :content

  def points
    liking_users.count
  end

  def liked_by?(user)
    liking_users.exists?(user.id)
  end

  private

  def sanitize_content
    self.content = ActionController::Base
                   .helpers
                   .sanitize(content,
                             tags: %w[b i u p br strong em a],
                             attributes: %w[href])
  end
end
