class User < ApplicationRecord
    has_secure_password
    has_many :posts,            dependent: :destroy
    has_many :liking_relations, foreign_key: :liking_user_id
    has_many :liked_posts,      through: :liking_relations,
                                source: :liked_post

    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true

    def User.digest(string)
        BCrypt::Password.create(string)
    end
end
