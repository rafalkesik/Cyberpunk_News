class Category < ApplicationRecord
  has_many :posts
  validates :title, :description, presence: true, uniqueness: true
end
