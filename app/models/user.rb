class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts,    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_likes,  foreign_key: :liking_user_id,
                         dependent: :destroy
  has_many :liked_posts, through: :post_likes,
                         source: :liked_post
  has_many :comment_likes,  foreign_key: :liking_user_id,
                            dependent: :destroy
  has_many :liked_comments, through: :comment_likes,
                            source: :liked_comment

  before_validation :sanitize_username
  validates :username, presence: true, uniqueness: true

  def author_of_post?(post)
    post.user == self
  end

  def author_of_comment?(comment)
    comment.user == self
  end

  # Changes default devise mailer into SendGrid API on production ENV
  def send_devise_notification(notification, *args)
    MailerService.send_email(self, notification, *args)
  end

  private

  def sanitize_username
    self.username = ActionController::Base
                    .helpers
                    .sanitize(username)
  end
end
