class User < ApplicationRecord
  has_secure_password
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
  validates :password, presence: true, confirmation: true

  def self.digest(string)
    BCrypt::Password.create(string)
  end

  def admin?
    self.admin
  end

  def author_of_post?(post)
    post.user == self
  end

  def author_of_comment?(comment)
    comment.user == self
  end
end
