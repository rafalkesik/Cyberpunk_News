class Category < ApplicationRecord
  has_many :posts
  validates :title, :description, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9\-\_]+\z/,
                             message: I18n.t(:slug_format_error) }
end
