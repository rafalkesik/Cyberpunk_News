class AddCategoryToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :category, foreign_key: true, null: false, default: 1
  end
end
