class AddUniqueIndexToLikingRelations < ActiveRecord::Migration[7.0]
  def change
    add_index :liking_relations, [:liking_user_id, :liked_post_id], unique: true
  end
end
