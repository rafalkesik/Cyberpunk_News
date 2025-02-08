class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts,            dependent: :destroy
  has_many :comments,         dependent: :destroy
  has_many :liking_relations, foreign_key: :liking_user_id,
                              dependent: :destroy
  has_many :liked_posts,      through: :liking_relations,
                              source: :liked_post
  has_many :comment_liking_relations, foreign_key: :liking_user_id,
                                      dependent: :destroy
  has_many :liked_comments, through: :comment_liking_relations,
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
    # Generate the Devise mailer message
    message = devise_mailer.send(notification, self, *args)

    # Extract email subject and content
    subject = message.subject
    content = message.body.raw_source # Extract raw email content (text/html)

    # Send email using SendGrid API
    ApplicationMailer.new.send_email(email, subject, content)
  end
end
