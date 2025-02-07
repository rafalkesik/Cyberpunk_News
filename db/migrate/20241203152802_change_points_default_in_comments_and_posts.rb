class ChangePointsDefaultInCommentsAndPosts < ActiveRecord::Migration[7.0]
  def change
    # ⚠️ Note: This migration contains a bad practice of data update.
    # Schema changes (like `change_column_default`) belong in migrations, but data updates should be done separately.
    # A better approach would be:
    #   1. Running the schema change in this migration.
    #   2. Creating a separate rake task to update existing records.
    #      Or updating the db manually through psql in CLI.
    # Keeping this migration unchanged for historical consistency.
    # This migration has been undone by migration 20250206103315.
    Comment.where(points: nil).update_all(points: 0)
    Post.where(points: nil).update_all(points: 0)

    change_column_default :comments, :points, 0
    change_column_default :posts, :points, 0
  end
end
