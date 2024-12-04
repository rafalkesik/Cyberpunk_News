class ChangePointsDefaultInCommentsAndPosts < ActiveRecord::Migration[7.0]
  def change
    Comment.where(points: nil).update_all(points: 0)
    Post.where(points: nil).update_all(points: 0)

    change_column_default :comments, :points, 0
    change_column_default :posts, :points, 0
  end
end
