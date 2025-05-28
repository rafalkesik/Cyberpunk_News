class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments,     dependent: :destroy
  has_many :post_likes,   foreign_key: :liked_post_id,
                          dependent: :destroy
  has_many :liking_users, through: :post_likes,
                          source: :liking_user

  before_validation :sanitize_title, :sanitize_content, :sanitize_link

  validates :title,   presence: true
  validates :link,    presence: true,
                      unless: ->(post) { post.content.present? }
  validates :link,    format: { with: URI::DEFAULT_PARSER.make_regexp,
                                message: (I18n.t 'error.invalid_url') },
                      allow_blank: true
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

  private

  def sanitize_title
    self.title = ActionController::Base
                 .helpers
                 .sanitize(title)
  end

  def sanitize_content
    self.content = ActionController::Base
                   .helpers
                   .sanitize(content,
                             tags: %w[b i u p br strong em a],
                             attributes: %w[href])
  end

  def sanitize_link
    self.link = ActionController::Base
                .helpers
                .sanitize(link)
  end
end
