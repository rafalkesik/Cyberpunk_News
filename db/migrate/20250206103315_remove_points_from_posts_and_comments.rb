class RemovePointsFromPostsAndComments < ActiveRecord::Migration[7.1]
  def change
    # Points are now defined inside models by likes count.
    remove_column :comments, :points, :integer
    remove_column :posts, :points, :integer
  end
end
