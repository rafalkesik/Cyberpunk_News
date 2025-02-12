class RenameLikingRelations < ActiveRecord::Migration[7.1]
  def change
    rename_table :liking_relations, :post_likes
    rename_table :comment_liking_relations, :comment_likes
  end
end
