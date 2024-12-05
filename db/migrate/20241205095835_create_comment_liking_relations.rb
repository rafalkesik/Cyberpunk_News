class CreateCommentLikingRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_liking_relations do |t|
      t.integer :liking_user_id, index: true
      t.integer :liked_comment_id, index: true

      t.timestamps
    end
    add_index :comment_liking_relations,
              [:liking_user_id, :liked_comment_id],
              unique: true,
              name: 'index_liking_user_and_comment'
  end
end
