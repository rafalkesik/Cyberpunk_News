class AddHiddenToComment < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :hidden, :boolean, default: false
  end
end
