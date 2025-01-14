class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :slug
      t.string :title
      t.string :description

      t.timestamps
    end

    Category.create(slug: "inne",
                    title: "Inne",
                    description: "Posty niepasujące do żadnej kategorii.")
  end
end
