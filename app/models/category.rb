class Category < ApplicationRecord
  has_many :posts
  before_validation :sanitize_title, :sanitize_description
  validates :title, :description, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9\-_]+\z/,
                             message: I18n.t(:slug_format_error) }

  private

  def sanitize_title
    self.title = ActionController::Base
                 .helpers
                 .sanitize(title)
  end

  def sanitize_description
    self.description = ActionController::Base
                       .helpers
                       .sanitize(description,
                                 tags: %w[b u i p br a strong em],
                                 attributes: %w[href])
  end
end
