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

  validates :username, presence: true, uniqueness: true

  def author_of_post?(post)
    post.user == self
  end

  def author_of_comment?(comment)
    comment.user == self
  end

  # Changes default devise mailer to SendGrid API method
  def send_devise_notification(notification, *args)
    # Default behaviour for dev env
    if Rails.env.development?
      send_devise_notification_dev_env(notification, *args)
      return
    end

    # Generate the Devise mailer message
    message = devise_mailer.send(notification, self, *args)

    # Extract email subject and content
    subject = message.subject
    content = message.body.raw_source # Extract raw email content (text/html)

    # Send email using SendGrid API
    ApplicationMailer.new.send_email(email, subject, content)
  end

  def send_devise_notification_dev_env(notification, *args)
    message = devise_mailer.send(notification, self, *args)
    if message.respond_to?(:deliver_now)
      message.deliver_now
    else
      message.deliver
    end
  end
end
