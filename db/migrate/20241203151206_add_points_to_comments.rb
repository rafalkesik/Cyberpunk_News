class AddPointsToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :points, :integer
  end
end
