class CreateLikingRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :liking_relations do |t|
      t.integer :liking_user_id, index: true
      t.integer :liked_post_id,  index: true

      t.timestamps
    end
  end
end
