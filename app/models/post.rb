class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category,       optional: true
  has_many :comments,         dependent: :destroy
  has_many :liking_relations, foreign_key: :liked_post_id,
                              dependent: :destroy
  has_many :liking_users,     through: :liking_relations,
                              source: :liking_user

  validates :title,   presence: true
  validates :link,    presence: true,
                      unless: ->(post) { post.content.present? }
  validates :content, presence: true,
                      unless: ->(post) { post.link.present? }

  def points
    liking_users.count
  end

  def liked_by?(user)
    self.liking_relations.find_by(liking_user: user).present?
  end

  def short_link
    @link = link.sub(%r{https://|http://}, '')
    @link = @link.sub(/www./, '')
    @link.sub(%r{/.*}, '')
  end
end
