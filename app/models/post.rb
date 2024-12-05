class Post < ApplicationRecord

    belongs_to :user
    has_many :comments,         dependent: :destroy
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

    def is_liked_by?(user)
        !!my_liking_relation(user)
    end

    def my_liking_relation(user)
        liking_relations.find_by(liking_user: user) if user
    end

    def short_link
        @link = link.sub(/https:\/\/|http:\/\//, "")
        @link = @link.sub(/www./, "")
        @link.sub(/\/.*/, "")
    end

    def icon_data(current_user)
        if self.is_liked_by?(current_user)
            { method: :delete, class: 'text-highlight' }
        else
            { method: :post, class: 'text-secondary' }
        end
    end
end
