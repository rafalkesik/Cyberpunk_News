class Post < ApplicationRecord
    belongs_to :user, class_name: '::User'
    validates :title, presence: true
    validates :link, presence: true, unless: ->(post) { post.content.present? }
    validates :content, presence: true, unless: ->(post) { post.link.present? }

    def short_link
        @link = link.sub(/https:\/\/|http:\/\//, "")
        @link = @link.sub(/www./, "")
        @link.sub(/\/.*/, "")
    end
end
