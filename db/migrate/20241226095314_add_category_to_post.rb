class AddCategoryToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :category
  end
end
