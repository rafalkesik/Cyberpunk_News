class Post < ApplicationRecord

    belongs_to :user
    has_many :liking_relations, foreign_key: :liked_post_id
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

    def short_link
        @link = link.sub(/https:\/\/|http:\/\//, "")
        @link = @link.sub(/www./, "")
        @link.sub(/\/.*/, "")
    end
end
