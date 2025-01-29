class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :slug
      t.string :title
      t.string :description

      t.timestamps
    end

    # This should not have happened in migration, but in seeds.
    # But migrations should not be edited, so it will remain here.
    Category.create(slug: 'inne',
                    title: 'Inne',
                    description: 'Posty niepasujące do żadnej kategorii.')
  end
end
