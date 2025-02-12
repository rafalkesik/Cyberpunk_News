class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments,     dependent: :destroy
  has_many :post_likes,   foreign_key: :liked_post_id,
                          dependent: :destroy
  has_many :liking_users, through: :post_likes,
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
    liking_users.exists?(user.id)
  end

  def short_link
    link.sub(%r{https://|http://}, '')
        .sub(/www./, '')
        .sub(%r{/.*}, '')
  end
end
