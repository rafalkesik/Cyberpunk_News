class User < ApplicationRecord
    has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true

    def User.digest(string)
        BCrypt::Password.create(string)
    end
end
